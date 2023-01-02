import sys

import asyncio
import aioconsole

import pickle
import time

from multiprocessing import Pool

from role import Role

from concurrent.futures import ThreadPoolExecutor
from GUI import GUI, ModelMsgMgr



EXECUTOR = ThreadPoolExecutor()
CMDS_IN_ROLE_DICT = Role.__dict__
CMDS_IN_MODEL_MSG_MGR = ModelMsgMgr.__dict__
# CMDS_IN_SER_MSG_MGR = SerMsgMgr.__dict__

WAIT_FOR_ROLE_CMDS = True
WAIT_SECS = 0.5
GET_USER_INPUT = False
GUI_ON = True

AUTO_SEND_MSGS_FOR_CLIENT_1 = [
    # enter world
    'login@test_name@test_pwd',
    # 'get_worlds',
    # 'get_pcs_in_world@2',
    'create_pc@role_1',
    'enter_world_as_pc@49',
    # 'move_to@100@100',
    # 'select_target@50',
    # in world now
    # 'move_to@1@2',
    # 'enter_port@33',
    # 'sail',
    # 'discover@11',
    # 'buy_ship@1@hawk11',
    # 'buy_ship@2@harry11',
    # 'sell_ship@harry11',
    # 'buy_commodity@22@5@hawk11',
    # 'buy_commodity@22@6@hawk11',
    # 'sell_commodity@22@hawk11',
    # 'lv_up',

    'select_target@50',

    # 'enter_battle_with_target',
    # 'attack_target',
    # 'all_ships_operate',
    # logout
    # 'logout',
]

AUTO_SEND_MSGS_FOR_CLIENT_2 = [
    # enter world
    'login@test_name@test_pwd',
    # 'get_worlds',
    # 'get_pcs_in_world@2',
    'create_pc@role_2',
    'enter_world_as_pc@50',

    # in world now
    # 'buy_ship@1@ship_name1',
    # 'move_to@100@100',
    # 'move_to@55@66',
    # 'enter_port@33',

    # 'sail',
    # 'discover@11',
    # 'buy_ship@1@hawk11',
    # 'buy_ship@2@harry11',
    # 'sell_ship@harry11',
    # 'buy_commodity@22@5@hawk11',
    # 'buy_commodity@22@6@hawk11',
    # 'sell_commodity@22@hawk11',
    # 'lv_up',

    # 'select_target@38',

    # logout
    # 'logout',
]

AUTO_SEND_MSGS_FOR_CLIENT_3 = [
    # enter world
    'login@test_name@test_pwd',
    # 'get_worlds',
    # 'get_pcs_in_world@2',
    'create_pc@role_3',
    'enter_world_as_pc@51',



    # 'select_target@38',

    # logout
    # 'logout',
]



class SerMsgMgr:

    async def this_is_your_pc_data(self, ojb_bytes):
        print('detected pc data from server!!')
        # ojb_bytes = data.decode()[21:]

        li = pickle.loads(eval(ojb_bytes))
        my_pc_id = li[0]
        pc_id_2_role = li[1]

        my_pc = pc_id_2_role[my_pc_id]

        print(my_pc)
        print(f'name: {my_pc.name}')
        print(f'lv: {my_pc.lv}')
        print(f'x: {my_pc.pos.x}')
        print(f'y: {my_pc.pos.y}')
        print(f'ships: {my_pc.ship_name_2_ins}')

        self.pc = pc_id_2_role[my_pc_id]
        self.pc_id_2_role = pc_id_2_role

        self.pc.pc_id_2_role = pc_id_2_role
        self.pc.pc_id = my_pc_id

        # every role needs to maintain all other roles and client
        for pc_id, role in pc_id_2_role.items():
            role.pc_id_2_role = pc_id_2_role
            role.client = self
            role.pc_id = pc_id

        # init my player sp
        msg = f'init_player_sp@{pc_id}'
        self.pc.send_msg_to_view(msg)

        # init other players sps
        for pc_id, role in pc_id_2_role.items():
            if pc_id != my_pc_id:
                to_x, to_y = Role.calc_distance_from_other_role_to_my_role(role, self.pc)
                msg = f'init_other_player_sp@{pc_id}@{to_x}@{to_y}'
                self.pc.send_msg_to_view(msg)

        print(f'id of self.pc {id(self.pc)}')
        print(f'id of {id(self.pc.pc_id_2_role[my_pc_id])}')

        print(f'### all roles i know ###')
        print(f'self.pc_id_2_role: {self.pc_id_2_role}')

    async def someone_entered_world(self, ojb_bytes):
        print('someone entered world!!')
        # ojb_bytes = data.decode()[22:]

        li = pickle.loads(eval(ojb_bytes))
        pc_id = li[0]
        role = li[1]
        print(f'{role.name} entered world')

        self.pc_id_2_role[pc_id] = role
        # this new role needs to know all roles as well and client
        role.pc_id_2_role = self.pc_id_2_role
        role.client = self
        role.pc_id = pc_id
        print(f'### all roles i know ###')
        print(f'self.pc_id_2_role: {self.pc_id_2_role}')

        # send msg to view
        to_x, to_y = Role.calc_distance_from_other_role_to_my_role(role, self.pc)

        msg = f'init_other_player_sp@{pc_id}@{to_x}@{to_y}'
        self.pc.send_msg_to_view(msg)

    async def someones_entered_world(self, ojb_bytes):
        print('someones entered world!!')
        # ojb_bytes = data.decode()[23:]

        pc_id_2_role = pickle.loads(eval(ojb_bytes))
        for pc_id, role in pc_id_2_role.items():
            print(f'{role.name} entered world')
            self.pc_id_2_role[pc_id] = role
            # this new role needs to know all roles as well and client
            role.pc_id_2_role = self.pc_id_2_role
            role.client = self
            role.pc_id = pc_id
            print(f'### all roles i know ###')
            print(f'self.pc_id_2_role: {self.pc_id_2_role}')

            # send msg to view
            to_x, to_y = Role.calc_distance_from_other_role_to_my_role(role, self.pc)

            msg = f'init_other_player_sp@{pc_id}@{to_x}@{to_y}'
            self.pc.send_msg_to_view(msg)

    async def someone_left_world(self, ojb_bytes):
        print('someone left world!!')
        # ojb_bytes = data.decode()[19:]
        pc_id = pickle.loads(eval(ojb_bytes))
        del self.pc_id_2_role[pc_id]
        print(f'self.pc_id_2_role: {self.pc_id_2_role}')

        msg = f'rm_other_player_sp@{pc_id}'
        self.pc.send_msg_to_view(msg)

    async def someones_left_world(self, ojb_bytes):
        print('someones left world!!')
        # ojb_bytes = data.decode()[20:]
        pc_ids = pickle.loads(eval(ojb_bytes))
        for pc_id in pc_ids:
            del self.pc_id_2_role[pc_id]
            msg = f'rm_other_player_sp@{pc_id}'
            self.pc.send_msg_to_view(msg)

    async def someone_ran_cmd(self, ojb_bytes):
        print('someone ran cmd:!!')
        # ojb_bytes = data.decode()[16:]
        li = pickle.loads(eval(ojb_bytes))

        pc_id = li[0]
        msg = li[1]

        # parse cmd
        cmd, args = self.parse_msg(msg)
        func = getattr(self.pc_id_2_role[pc_id], cmd)
        await self.run_cmd_in_role(func, args)
        print(f'{pc_id} ran cmd {cmd} with {args}')
        print(f'self.pc.is_in_battle: {self.pc.is_in_battle}')
        print(f'id of self.pc  {id(self.pc)}')

    async def you_entered_port(self, ojb_bytes):
        print('you entered port!!')
        # ojb_bytes = data.decode()[17:]

        li = pickle.loads(eval(ojb_bytes))
        my_pc_id = li[0]
        pc_id_2_role = li[1]

        my_pc = pc_id_2_role[my_pc_id]

        self.pc = pc_id_2_role[my_pc_id]
        prev_pc_id_2_role = self.pc_id_2_role
        self.pc_id_2_role = pc_id_2_role

        self.pc.pc_id_2_role = pc_id_2_role
        self.pc.pc_id = my_pc_id

        # every role needs to maintain all other roles and client
        for pc_id, role in pc_id_2_role.items():
            role.pc_id_2_role = pc_id_2_role
            role.client = self
            role.pc_id = pc_id

        # change bg to port
        self.pc.send_msg_to_view(f'change_bg_to@port')

        # clear prev other players sps
        for pc_id, role in prev_pc_id_2_role.items():
            if pc_id != my_pc_id:
                self.pc.send_msg_to_view(f'rm_other_player_sp@{pc_id}')

        # init other players sps
        for pc_id, role in pc_id_2_role.items():
            if pc_id != my_pc_id:
                to_x, to_y = Role.calc_distance_from_other_role_to_my_role(role, self.pc)
                msg = f'init_other_player_sp@{pc_id}@{to_x}@{to_y}'
                self.pc.send_msg_to_view(msg)

        print(f'id of self.pc {id(self.pc)}')
        print(f'id of {id(self.pc.pc_id_2_role[my_pc_id])}')

        print(f'### all roles i know ###')
        print(f'self.pc_id_2_role: {self.pc_id_2_role}')

    async def you_sailed(self, ojb_bytes):
        print('you sailed!!')

        li = pickle.loads(eval(ojb_bytes))
        my_pc_id = li[0]
        pc_id_2_role = li[1]

        my_pc = pc_id_2_role[my_pc_id]

        self.pc = pc_id_2_role[my_pc_id]
        prev_pc_id_2_role = self.pc_id_2_role
        self.pc_id_2_role = pc_id_2_role

        self.pc.pc_id_2_role = pc_id_2_role
        self.pc.pc_id = my_pc_id

        # every role needs to maintain all other roles and client
        for pc_id, role in pc_id_2_role.items():
            role.pc_id_2_role = pc_id_2_role
            role.client = self
            role.pc_id = pc_id

        # change bg to port
        self.pc.send_msg_to_view(f'change_bg_to@sea')

        # clear prev other players sps
        for pc_id, role in prev_pc_id_2_role.items():
            if pc_id != my_pc_id:
                self.pc.send_msg_to_view(f'rm_other_player_sp@{pc_id}')

        # init other players sps
        for pc_id, role in pc_id_2_role.items():
            if pc_id != my_pc_id:
                to_x, to_y = Role.calc_distance_from_other_role_to_my_role(role, self.pc)
                msg = f'init_other_player_sp@{pc_id}@{to_x}@{to_y}'
                self.pc.send_msg_to_view(msg)

        print(f'id of self.pc {id(self.pc)}')
        print(f'id of {id(self.pc.pc_id_2_role[my_pc_id])}')

        print(f'### all roles i know ###')
        print(f'self.pc_id_2_role: {self.pc_id_2_role}')

    async def you_entered_battle(self, ojb_bytes):
        print('you entered port!!')

        li = pickle.loads(eval(ojb_bytes))
        my_pc_id = li[0]
        pc_id_2_role = li[1]

        my_pc = pc_id_2_role[my_pc_id]

        self.pc = pc_id_2_role[my_pc_id]
        prev_pc_id_2_role = self.pc_id_2_role
        self.pc_id_2_role = pc_id_2_role

        self.pc.pc_id_2_role = pc_id_2_role
        self.pc.pc_id = my_pc_id

        # every role needs to maintain all other roles and client
        for pc_id, role in pc_id_2_role.items():
            role.pc_id_2_role = pc_id_2_role
            role.client = self
            role.pc_id = pc_id

        # change bg to port
        self.pc.send_msg_to_view(f'change_bg_to@battle_field')

        # clear all players sps
        for pc_id, role in prev_pc_id_2_role.items():
            self.pc.send_msg_to_view(f'rm_other_player_sp@{pc_id}')

        # init my ships
        for name, ship in self.pc.ship_name_2_ins.items():
            msg = f'init_my_ship_in_battle@{name}@{ship.x}@{ship.y}'
            self.pc.send_msg_to_view(msg)

        # init enemy ships
        for name, ship in self.pc.target_role.ship_name_2_ins.items():
            msg = f'init_enemy_ship_in_battle@{name}@{ship.x}@{ship.y}'
            self.pc.send_msg_to_view(msg)

    async def you_exited_battle(self, ojb_bytes):
        print('you exited battle!!')

        li = pickle.loads(eval(ojb_bytes))
        my_pc_id = self.pc.pc_id
        pc_id_2_role = li[1]

        my_pc = pc_id_2_role[my_pc_id]

        self.pc = pc_id_2_role[my_pc_id]
        self.pc_id_2_role = pc_id_2_role

        self.pc.pc_id_2_role = pc_id_2_role
        self.pc.pc_id = my_pc_id

        # every role needs to maintain all other roles and client
        for pc_id, role in pc_id_2_role.items():
            role.pc_id_2_role = pc_id_2_role
            role.client = self
            role.pc_id = pc_id

        # change bg to port
        self.pc.send_msg_to_view(f'change_bg_to@sea')

        # rm all ship in battle
        msg = f'rm_all_ships_in_battle'
        self.pc.send_msg_to_view(msg)

        # init my player sp
        msg = f'init_player_sp@{self.pc.pc_id}'
        self.pc.send_msg_to_view(msg)

        # init other players sps
        for pc_id, role in pc_id_2_role.items():
            if pc_id != my_pc_id:
                to_x, to_y = Role.calc_distance_from_other_role_to_my_role(role, self.pc)
                msg = f'init_other_player_sp@{pc_id}@{to_x}@{to_y}'
                self.pc.send_msg_to_view(msg)

    async def you_can_do_all_ships_operate(self, x):
        msg = f'all_ships_operate'
        self.gui_msgs_queue.append(msg)


class Client:
    CMDS_IN_SER_MSG_MGR = SerMsgMgr.__dict__

    def __init__(self, client_id):
        self.client_id = client_id

        self.pc = None
        self.pc_id_2_role = None
        self.gui = None
        self.reader = None
        self.writer = None

        # msgs from gui(controller) to model
        self.gui_msgs_queue = []
        # msgs from model to gui(view)
        self.model_msgs_queue = []

    def parse_msg(self, msg):
        split_items = msg.split('@')
        cmd = split_items[0]
        args = split_items[1:]

        # turn digits from str to int
        new_args = []
        for arg in args:
            if arg.lstrip("-").isdigit():
                new_args.append(int(arg))
            else:
                new_args.append(arg)

        return cmd, new_args

    def run_cmd_in_gui(self, func, args):
        len_of_args = len(args)
        if len_of_args == 0:
            func()
        elif len_of_args == 1:
            func(args[0])
        elif len_of_args == 2:
            func(args[0], args[1])
        elif len_of_args == 3:
            func(args[0], args[1], args[2])
        elif len_of_args == 4:
            func(args[0], args[1], args[2], args[3])
        elif len_of_args == 5:
            func(args[0], args[1], args[2], args[3], args[4])
        else:
            print(f'!!!!!!!!! too many args !!!!!!!')

    async def run_cmd_in_role(self, func, args):
        len_of_args = len(args)
        if len_of_args == 0:
            await func()
        elif len_of_args == 1:
            await func(args[0])
        elif len_of_args == 2:
            await func(args[0], args[1])
        elif len_of_args == 3:
            await func(args[0], args[1], args[2])
        elif len_of_args == 4:
            await func(args[0], args[1], args[2], args[3])
        else:
            print(f'!!!!!!!!! too many args !!!!!!!')

    async def send_msg_and_run_cmd(self, msg):

        # parse cmd
        cmd, args = self.parse_msg(msg)

        # send msg
        print(f'\n###### Sent: {msg}\n')
        self.writer.write(msg.encode())
        await self.writer.drain()

        # if cmd in role
        if cmd in CMDS_IN_ROLE_DICT:
            # run cmd in role
            func = getattr(self.pc, cmd)
            print(f'\n!!!!! gonna run {cmd} with {args}')
            await self.run_cmd_in_role(func, args)
            print(f'\n!!!!! Ran {cmd} with {args}')

    def send_msg_to_gui(self, msg):
        # parse cmd
        cmd, args = self.parse_msg(msg)
        if cmd in CMDS_IN_MODEL_MSG_MGR:
            # run cmd in role
            func = getattr(ModelMsgMgr, cmd)
            args.insert(0, self.gui)
            self.run_cmd_in_gui(func, args)
            print(f'\n!!!!! GUI Ran {cmd} with {args}')

    async def send_gui_msgs_co(self):
        while True:
            if self.gui_msgs_queue:
                msg = self.gui_msgs_queue.pop(0)
                await self.send_msg_and_run_cmd(msg)
            else:
                await asyncio.sleep(0.01)

    async def send_model_msgs_co(self):
        while True:
            if self.model_msgs_queue:
                msg = self.model_msgs_queue.pop(0)
                if self.gui:
                    self.send_msg_to_gui(msg)
            else:
                await asyncio.sleep(0.01)

    async def send_co(self, reader, writer):
        # get auto_send_msgs bases on client
        if self.client_id == '1':
            auto_send_msgs = AUTO_SEND_MSGS_FOR_CLIENT_1
        elif self.client_id == '2':
            auto_send_msgs = AUTO_SEND_MSGS_FOR_CLIENT_2
        elif self.client_id == '3':
            auto_send_msgs = AUTO_SEND_MSGS_FOR_CLIENT_3

        # for each msg
        for msg in auto_send_msgs:
            if GET_USER_INPUT:
                msg = await aioconsole.ainput()

            await asyncio.sleep(0.2)

            # parse cmd
            cmd, args = self.parse_msg(msg)

            # send msg
            print(f'\n###### Sent: {msg}\n')
            writer.write(msg.encode())
            await writer.drain()

            # if cmd in role
            if cmd in CMDS_IN_ROLE_DICT:
                # run cmd in role
                if WAIT_FOR_ROLE_CMDS:
                    await asyncio.sleep(WAIT_SECS)
                func = getattr(self.pc, cmd)
                print(f'\n!!!!! gonna run {cmd} with {args}')
                await self.run_cmd_in_role(func, args)
                print(f'\n!!!!! Ran {cmd} with {args}')

    async def recv_co(self, reader, writer):
        while True:
            # recv
            data = await reader.read(5000)

            print(f'\n###### Got: {data.decode()[:20]}')
            # exit if got ''
            if not data:
                exit()

            await self.handle_server_msg(reader, writer, data)

    async def handle_server_msg(self, reader, writer, data):

        # to str
        msg = data.decode()

        # get func_name and obj_bytes
        func_name = ''
        index = 0

        while True:
            char = msg[index]
            if char == ':':
                break
            index += 1

        func_name = msg[:index]
        print(f'func_name: {func_name}')
        index += 1
        ojb_bytes = msg[index:]

        # run this func
        if func_name in Client.CMDS_IN_SER_MSG_MGR:
            func = getattr(SerMsgMgr, func_name)
            await func(self, ojb_bytes)

    async def gui_co(self):
        if GUI_ON:
            gui = GUI(client=self)
            self.gui = gui
            await gui.run()
        else:
            return

    async def start(self):
        # conn
        reader, writer = await asyncio.open_connection(
            '127.0.0.1', 8888)
        self.reader = reader
        self.writer = writer


        # Schedule three calls *concurrently*:
        await asyncio.gather(
            self.send_co(reader, writer),
            self.recv_co(reader, writer),
            self.gui_co(),
            self.send_gui_msgs_co(),
            self.send_model_msgs_co(),
        )

    def main(self):
        asyncio.run(self.start())



def run_client(client_id=1):
    c = Client(client_id)
    c.main()


def run_mutiple_clients(CLIENT_CNT):
    """ run a few clients using process pool """
    inputs = []
    for i in range(CLIENT_CNT):
        inputs.append(i)

    with Pool(CLIENT_CNT) as p:
        print(p.map(run_client, inputs))


def get_client_option():
    """1 or 2"""
    args = sys.argv[1:]
    client_id = args[0]
    print(f'client_id: {client_id}')
    return client_id


def main():
    client_id = get_client_option()
    run_client(client_id)


if __name__ == '__main__':
    main()