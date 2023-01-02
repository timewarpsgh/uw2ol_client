import asyncio
import random
import time
from enum import Enum
from concurrent.futures import ThreadPoolExecutor

EXECUTOR = ThreadPoolExecutor()

SLEEP_TIME = 0.2 #0.2
SHOOT_DAMAGE = 40 # 25
DIR_2_DX_DY = {
    's': [0, -16],
    'n': [0, 16],
    'w': [16, 0],
    'e': [-16, 0],
}
SECS_TO_THINK_IN_BATTLE = 30
MUST_MOVE_BEFORE_SECS = 25
TAKE_TURNS_IN_BATTLE = False

class Direction(Enum):
    n = 1
    s = 2
    e = 3
    w = 4

class Pos:
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y


class Ship:
    def __init__(self, id, name):
        self.id = id
        self.name = name
        self.commodity_id_2_cnt = {1:10,
                                   2:10,}

        self.max_hp = 100
        self.now_hp = 100
        self.x = 0
        self.y = 0

    def shoot(self, ship):
        ship.now_hp -= SHOOT_DAMAGE
        print(f'  ship {self.name} shot target ship {ship.name}, '
              f'target ship now has hp: {ship.now_hp}')

        is_target_ship_sunk = False
        if ship.now_hp <= 0:
            is_target_ship_sunk = True

        print(f'  is_target_ship_sunk: {is_target_ship_sunk}\n')
        return is_target_ship_sunk

    def move(self):
        self.x += 10
        print(f'  ship {self.name} moved!')

    def __str__(self):
        return f'name: {self.name} - ' \
               f'now_hp: {self.now_hp} - ' \
               f'commodity: {self.commodity_id_2_cnt}'


class Role:
    def __init__(self, name, lv, client=None):
        self.client = client
        self.pc_id = None

        # all roles in game
        self.pc_id_2_role = None

        # target role
        self.target_role = None

        self.name = name

        # positions
        self.pos = Pos()
        self.is_at_sea = True
        self.is_in_port = False
        self.in_port_id = None
        self.is_in_battle = False
        self.in_battle_id = None

        # posessions
        self.lv = lv
        self.gold = 2000
        self.discovery_ids_set = set()
        self.ship_name_2_ins = {
            '0': Ship(1, '0'),
            '1': Ship(1, '1'),
            '2': Ship(1, '2'),
            '3': Ship(1, '3'),
        }
        self.flag_ship_name = '0'
        self.secs_left = SECS_TO_THINK_IN_BATTLE

    def send_msg_to_view(self, msg):
        if self.client:
            self.client.model_msgs_queue.append(msg)
            print(f'\n####### sent msg to view: {msg}')

    def send_msgs_to_view(self, msgs):
        if self.is_in_client():
            for msg in msgs:
                self.send_msg_to_view(msg)

    async def move_to(self, x, y):
        self.pos.x = x
        self.pos.y = y

        msg = f'mv_bg_to@{self.pos.x}@{self.pos.y}'
        self.send_msg_to_view(msg)

    def after_move(self):
        # if my role
        if id(self) == id(self.client.pc):
            # self movement
            msg = f'mv_bg_to@{self.pos.x}@{self.pos.y}'
            self.send_msg_to_view(msg)

            # others movement
            for pc_id, role in self.pc_id_2_role.items():
                if id(role) != id(self.client.pc):
                    x = role.pos.x
                    y = role.pos.y

                    my_role_x = self.pos.x
                    my_role_y = self.pos.y

                    to_x = - x + my_role_x
                    to_y = - y + my_role_y

                    msg = f'mv_other_player_sp@{pc_id}@{to_x}@{to_y}'
                    self.send_msg_to_view(msg)

        # if other role
        else:
            x = self.pos.x
            y = self.pos.y

            my_role_x = self.client.pc.pos.x
            my_role_y = self.client.pc.pos.y

            to_x = - x + my_role_x
            to_y = - y + my_role_y

            msg = f'mv_other_player_sp@{self.pc_id}@{to_x}@{to_y}'
            self.send_msg_to_view(msg)

    async def move(self, direction):
        d_x = DIR_2_DX_DY[direction][0]
        d_y = DIR_2_DX_DY[direction][1]
        self.pos.x += d_x
        self.pos.y += d_y

        if self.client:
            self.after_move()

    async def discover(self, id):
        self.discovery_ids_set.add(id)
        print(f'found {id}')
        print(f'now set: {self.discovery_ids_set}')

    async def buy_ship(self, id, name):
        ship = Ship(id, name)
        self.ship_name_2_ins[name] = ship
        print(f'bought ship')
        print(f'now ships: {self.ship_name_2_ins}')
        self.gold -= 5
        print(f'now gold: {self.gold}')

    async def sell_ship(self, name):
        del self.ship_name_2_ins[name]
        self.gold += 5
        print(f'sold ship {name}')
        print(f'now ships: {self.ship_name_2_ins}')
        print(f'now gold: {self.gold}')

    async def buy_commodity(self, id, cnt, to_ship_name):
        # cnt = cnt
        ship = self.ship_name_2_ins[to_ship_name]

        if id in ship.commodity_id_2_cnt:
            print(f'com id in dict')
            ship.commodity_id_2_cnt[id] += cnt
        else:
            print(f'com id not in dict ')
            ship.commodity_id_2_cnt[id] = cnt

        buy_price = 1
        self.gold -= cnt * buy_price
        print(f'bought commodity')
        print(f'ship.commodity_id_2_cnt: {ship.commodity_id_2_cnt}')
        print(f'now gold: {self.gold}')

    async def sell_commodity(self, id, from_ship_name):
        ship = self.ship_name_2_ins[from_ship_name]

        cnt = ship.commodity_id_2_cnt[id]
        sell_price = 1
        self.gold += cnt * 1

        del ship.commodity_id_2_cnt[id]
        print(f'sold commodity')
        print(f'ship.commodity_id_2_cnt: {ship.commodity_id_2_cnt}')
        print(f'now gold: {self.gold}')

    async def select_target(self, target_id):
        """sepcial """
        self.target_role = self.pc_id_2_role[target_id]

        print(f'id of self.target_role: {id(self.target_role)}')
        print(f'id of self.pc_id_2_role[target_id]: {id(self.pc_id_2_role[target_id])}')


        print(f'self.pc_id_2_role: {self.pc_id_2_role}')
        print(f'self.target_role: {self.target_role.name}')
        print(f'id of target role: {id(self.target_role)}')

    def after_enter_battle_with_target(self):
        # change bg
        msg = f'change_bg_to@battle_field'
        self.send_msg_to_view(msg)

        # rm all players sps
        for pc_id in self.pc_id_2_role.keys():
            msg = f'rm_other_player_sp@{pc_id}'
            self.send_msg_to_view(msg)

        # if is player (active)
        if id(self.client.pc) == id(self):

            # init my ships
            for name, ship in self.ship_name_2_ins.items():
                msg = f'init_my_ship_in_battle@{name}@{ship.x}@{ship.y}'
                self.send_msg_to_view(msg)

            # init enemy ships
            for name, ship in self.target_role.ship_name_2_ins.items():
                msg = f'init_enemy_ship_in_battle@{name}@{ship.x}@{ship.y}'
                self.send_msg_to_view(msg)

        # if is target (passive)
        elif id(self.client.pc) == id(self.target_role):

            # init my ships
            for name, ship in self.ship_name_2_ins.items():
                msg = f'init_enemy_ship_in_battle@{name}@{ship.x}@{ship.y}'
                self.send_msg_to_view(msg)

            # init enemy ships
            for name, ship in self.target_role.ship_name_2_ins.items():
                msg = f'init_my_ship_in_battle@{name}@{ship.x}@{ship.y}'
                self.send_msg_to_view(msg)

    # async def enter_battle_with_target(self):
    #
    #     # if no target
    #     if not self.target_role:
    #         print(f'need a target to battle with!!')
    #         return
    #
    #     # self
    #     self.is_in_battle = True
    #     self.in_battle_id = self.pc_id
    #     self.is_at_sea = False
    #     self.is_in_port = False
    #     self.secs_left = SECS_TO_THINK_IN_BATTLE
    #     for _id, name in enumerate(self.ship_name_2_ins.keys()):
    #         ship = self.ship_name_2_ins[name]
    #         ship.x = 200
    #         ship.y = 100 + _id * 30
    #
    #     # target
    #     t_role = self.target_role
    #     t_role.is_in_battle = True
    #     t_role.in_battle_id = self.pc_id
    #     t_role.is_at_sea = False
    #     t_role.is_in_port = False
    #     t_role.secs_left = 0
    #
    #
    #     t_role.target_role = self # set my target's target to myself
    #
    #     for _id, name in enumerate(self.target_role.ship_name_2_ins.keys()):
    #         ship = self.target_role.ship_name_2_ins[name]
    #         ship.x = 350
    #         ship.y = 100 + _id * 30
    #
    #     # prints
    #     print(f'{self.name} entered battle with {t_role.name}')
    #     print(f'{self.name} has target {self.target_role.name}')
    #     print(f'{self.target_role.name} has target {self.target_role.target_role.name}')
    #     print(f't_role.is_in_battle: {t_role.is_in_battle}')
    #
    #     # msg
    #     if self.client:
    #         self.after_enter_battle_with_target()
    #
    #     # reduce secs_left
    #     loop = asyncio.get_event_loop()
    #     loop.create_task(self.__reduce_secs_left())

    async def __reduce_secs_left(self):
        while self.is_in_battle:
            await asyncio.sleep(1)
            if self.secs_left > 0:
                self.secs_left -= 1
                print(f'self.secs_left: {self.secs_left}')


                if self.secs_left <= MUST_MOVE_BEFORE_SECS:
                    self.secs_left = 0
                    self.target_role.secs_left = SECS_TO_THINK_IN_BATTLE

                # show timer to enemy
                if self.is_my_pc_in_client():
                    msg = f'show_battle_timer@{self.secs_left}'
                    self.send_msg_to_view(msg)
                elif self.is_other_pc_in_client():

                    msg = f'show_wait_msg'
                    # self.send_msg_to_view(msg)

            elif self.target_role.secs_left > 0:
                self.target_role.secs_left -= 1
                print(f'self.target_role.secs_left: {self.target_role.secs_left}')

                if self.target_role.secs_left <= MUST_MOVE_BEFORE_SECS:
                    self.target_role.secs_left = 0
                    self.secs_left = SECS_TO_THINK_IN_BATTLE

                # show battle timer
                if self.is_my_pc_in_client():
                    msg = f'show_wait_msg'
                    # self.send_msg_to_view(msg)
                elif self.is_other_pc_in_client():
                    msg = f'show_battle_timer@{self.target_role.secs_left}'
                    self.send_msg_to_view(msg)

    def __get_flag_ship(self):
        return self.ship_name_2_ins[self.flag_ship_name]

    def __get_ships(self):
        return list(self.ship_name_2_ins.values())

    def after_deleting_target_ship(self, target_ship):
        if self.client:
            if id(self.client.pc) == id(self):

                msg = f'rm_enemy_ship_in_battle@{target_ship.name}'
                self.send_msg_to_view(msg)
            # if is other player (passive)
            elif id(self.client.pc) == id(self.target_role):
                msg = f'rm_my_ship_in_battle@{target_ship.name}'
                self.send_msg_to_view(msg)

    def is_in_client(self):
        if self.client:
            return True
        else:
            return False

    def is_other_pc_in_client(self):
        if self.is_in_client() and id(self.client.pc) != id(self):
            return True
        else:
            return False

    def is_my_pc_in_client(self):
        if self.is_in_client() and id(self.client.pc) == id(self):
            return True
        else:
            return False

    def after_ship_move(self, ship):
        if self.is_my_pc_in_client():
            msg = f'mv_my_ship_in_battle@{ship.name}@{ship.x}@{ship.y}'
            self.send_msg_to_view(msg)
        elif self.is_other_pc_in_client():
            msg = f'mv_enemy_ship_in_battle@{ship.name}@{ship.x}@{ship.y}'
            self.send_msg_to_view(msg)

    async def __one_ship_operate(self, ship):
        # move
        for i in range(3):
            ship.move()
            self.after_ship_move(ship)
            await asyncio.sleep(SLEEP_TIME)

        # choose target

        # get enemy_flag_ship
        enemy_flag_ship = self.target_role.__get_flag_ship()
        target_ship = enemy_flag_ship

        random.seed(self.gold)
        target_ship = random.choice(list(self.target_role.ship_name_2_ins.values()))

        # shoot target
        is_target_ship_sunk = ship.shoot(target_ship)

        # send msg
        msg = f'show_cannon_ball_from_to@{ship.x}@{ship.y}' \
              f'@{target_ship.x}@{target_ship.y}'
        self.send_msg_to_view(msg)

        await asyncio.sleep(SLEEP_TIME)

        # send msg
        msg = f'show_dmg_num_at@{SHOOT_DAMAGE}@{target_ship.x}@{target_ship.y}'
        self.send_msg_to_view(msg)
        msg = f'play_sound@explosion'
        self.send_msg_to_view(msg)


        return target_ship, is_target_ship_sunk

    def __win_battle(self):

        # receive all enemy's ships
        for ship in self.target_role.__get_ships():
            captured_ship_name = 'captured_' + ship.name
            self.ship_name_2_ins[captured_ship_name] = ship
            del self.target_role.ship_name_2_ins[ship.name]
            ship.name = captured_ship_name

        # change map
        self.__get_out_of_battle()

        # print new states
        print(f'my ships: {self.ship_name_2_ins}')
        print(f'enemy ships: {self.target_role.ship_name_2_ins}')

    @staticmethod
    def calc_distance_from_other_role_to_my_role(other_role, my_role):
        to_x = my_role.pos.x - other_role.pos.x
        to_y = my_role.pos.y - other_role.pos.y
        return to_x, to_y

    def __after_battle_ends(self):
        # my pc (won)
        if self.is_my_pc_in_client():
            # bg to sea
            msg = f'change_bg_to@sea'
            self.send_msg_to_view(msg)

            # rm all ship in battle
            msg = f'rm_all_ships_in_battle'
            self.send_msg_to_view(msg)

            # init my sp
            msg = f'init_player_sp@{self.pc_id}'
            self.send_msg_to_view(msg)

            # init target role sp
            to_x, to_y = Role.calc_distance_from_other_role_to_my_role\
                (self.target_role, self)
            msg = f'init_other_player_sp@{self.target_role.pc_id}@{to_x}@{to_y}'
            self.send_msg_to_view(msg)

        # other pc (lost)
        elif self.is_other_pc_in_client():
            msg = f'change_bg_to@port'
            self.send_msg_to_view(msg)

            msg = f'rm_all_ships_in_battle'
            self.send_msg_to_view(msg)

            msg = f'init_player_sp@{self.pc_id}'
            self.send_msg_to_view(msg)

            to_x, to_y = Role.calc_distance_from_other_role_to_my_role\
                (self, self.target_role)
            msg = f'init_other_player_sp@{self.target_role.pc_id}@{to_x}@{to_y}'
            self.send_msg_to_view(msg)

    async def all_ships_operate(self):
        print(f'#### {self.name} all_ships_operate')
        # if no secs left
        if TAKE_TURNS_IN_BATTLE and self.secs_left <=0:
            print(f'you have no secs left!!')
            return

        # for each ship
        for ship in self.__get_ships():
            # get enemy_flag_ship
            enemy_flag_ship = self.target_role.__get_flag_ship()

            # one ship operate
            target_ship, is_target_ship_sunk = await self.__one_ship_operate(ship)

            # if target sunk
            if is_target_ship_sunk:
                # delete target ship
                del self.target_role.ship_name_2_ins[target_ship.name]
                self.after_deleting_target_ship(target_ship)

                # if is flag ship
                if target_ship.name == enemy_flag_ship.name:
                    print(f'{self.target_role.name}  flag ship sunk!!!')
                    self.__win_battle()
                    self.__after_battle_ends()
                    break
                break

        # set secs_left
        self.secs_left = 0
        self.target_role.secs_left = SECS_TO_THINK_IN_BATTLE

    async def lv_up(self):
        self.lv += 1

    def is_in_same_map_as(self, role):
        if self.is_at_sea and role.is_at_sea:
            return True
        elif self.is_in_port and self.in_port_id == role.in_port_id:
            return True
        elif self.is_in_battle and role.is_in_battle:
            return True

        return False

    async def test(self):
        await self.buy_ship(1, 'ship_name')

        assert self.gold == 1995
        assert len(self.ship_name_2_ins) == 5


def print_results(role1, role2):
    print(f'\n######## results ##########')

    print(f'\n### {role1.name} ###')
    print('my ships:')
    for ship_name, ship in role1.ship_name_2_ins.items():
        print(ship)

    print('\ntarget ships:')
    for ship_name, ship in role1.target_role.ship_name_2_ins.items():
        print(ship)

    print(f'\n### {role2.name} ###')
    print('my ships:')
    for ship_name, ship in role2.ship_name_2_ins.items():
        print(ship)

    print('\ntarget ships:')
    for ship_name, ship in role2.target_role.ship_name_2_ins.items():
        print(ship)


async def main():
    # init roles
    role1 = Role(name='Tom', lv=1)
    role2 = Role(name='Jerry', lv=1)

    # select targets
    role1.target_role = role2
    role2.target_role = role1

    await role1.enter_battle_with_target()

    # take turns to attack
    for i in range(3):
        await role1.all_ships_operate()
        await role2.all_ships_operate()

    # print results
    print_results(role1, role2)


async def test():
    role1 = Role(name='Tom', lv=1)
    await role1.test()


if __name__ == '__main__':
    # asyncio.run(main())
    asyncio.run(test())
