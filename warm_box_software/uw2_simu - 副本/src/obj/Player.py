import random


from obj.Pos import Pos
from obj.Ship import Ship
from obj.Mate import Mate

from func.functions import \
    are_two_pos_the_same,\
    is_id_in_list_range

from data.dict import BUILDING_ID_2_TYPE
from data.scalar import MAX_SHIPS, MAX_MATES

class Role:
    def __init__(self, game, id, name):
        # parent
        self.game = game

        self.id = id
        self.name = name
        self.pos = Pos()
        self.found_discoveries_ids_set = set()

        self.in_port_id = None
        self.port = None
        self.in_building_id = None

        self.gold = 1000

        self.ships = [Ship(11, game), Ship(11, game), Ship(11, game)]
        print(f'role inited with ships')
        for ship in self.ships:
            print(f'{vars(ship)}')

        self.mates = [Mate(1)]

    def ____MOVE_FUNCS____(self):
        pass

    def move_to(self, x, y):
        self.pos.x = x
        self.pos.y = y

    def ____BATTLE_FIELD_FUNCS____(self):
        pass

    def fight_with_npc(self, id):
        print(f'\n### trying to fight_with_npc {id}')
        # get npc by id
        npc = self.game.npc_id_2_obj[id]

        # while 1
        while 1:

            # for each of my ships
            for ship in self.ships:
                # randomly pick one enemy ship to shoot
                npc_ships_cnt = len(npc.ships)
                ship_index = random.choice(range(npc_ships_cnt))

                is_target_dead = ship.shoot_ship(npc, ship_index)

                # if flag ship sunk
                if is_target_dead and ship_index == 0:
                    npc.ships.pop(ship_index)
                    print(f'enemy flag ship dead! we won!')

                    # get booty
                    self.ships.extend(npc.ships)
                    self.gold += npc.gold
                    print(f'#### got booty ships: {npc.ships} ####')
                    for ship in npc.ships:
                        print(f'{vars(ship)}')
                    print(f'#### got booty gold: {npc.gold} ####')

                    print(f'now my ships: {len(self.ships)}')
                    return

                # if non-flag ship sunk
                elif is_target_dead and ship_index != 0:
                    npc.ships.pop(ship_index)
                    print(f'!!!!!! npc ship {ship_index} just sunk !!!!!!!!')
                    print(f'npc current ships: {npc.ships}')


        print(f'{self.name} defeated {npc.name}')

    def ____BUILDING_FUNCS____(self):
        pass


    def ______MARKET____(self):
        pass

    def buy_commodity(self, id, cnt, to_ship_id):
        # if special
        if self.in_port.specialty and str(id) in self.in_port.specialty:
            print(f'\n the commodity to buy is special')
            target_ship = self.ships[to_ship_id]
            if target_ship.load_commodity(id, cnt):
                unit_buy_price = self.in_port.specialty[str(id)]
                self.gold -= int(unit_buy_price) * cnt
                print(f'bought commodity {id}, now gold {self.gold}')
                print(f'loaded {cnt} commodity {id} to ship {to_ship_id}')
                print(f'now cargo on it: {target_ship.commodity_id_2_cnt}')


        # if common
        elif id in self.game.economy_id_2_obj[self.in_port.economyId].available_commodities_ids:
            print(f'the commodity to buy is common')
            target_ship = self.ships[to_ship_id]
            if target_ship.load_commodity(id, cnt):
                commodity = self.game.commodity_id_2_obj[id]
                unit_buy_price = commodity.buy_price[str(self.in_port.economyId)]
                self.gold -= int(unit_buy_price) * cnt
                print(f'\nbought commodity {id}, now gold {self.gold}')
                print(f'loaded {cnt} commodity {id} to ship {to_ship_id}')
                print(f'now cargo on it: {target_ship.commodity_id_2_cnt}')

        # not available
        else:
            print(f'this commodity {id} is not available in tihs port {self.in_port.name}')


    def sell_commodity(self, id, cnt, from_ship_id):
        from_ship = self.ships[from_ship_id]
        if from_ship.unload_commodity(id, cnt):
            commodity = self.game.commodity_id_2_obj[id]
            unit_sell_price = commodity.sell_price[str(self.in_port.economyId)]
            self.gold += int(unit_sell_price) * cnt
            print(f'\nsold commodity {id}, now gold {self.gold}')
            print(f'unloaded {cnt} commodity {id} from ship {from_ship_id}')
            print(f'now cargo on it: {from_ship.commodity_id_2_cnt}')

    def ______DRYDOCK____(self):
        pass

    def buy_ship(self, id):
        if len(self.ships) < MAX_SHIPS:
            new_ship = Ship(id, self.game)
            self.ships.append(new_ship)
            self.gold -= self.game.ship_id_2_obj[id].price
            print(f'bought ship {id}, '
                  f'now gold: {self.gold}'
                  f'now ships: {self.ships}')

            for ship in self.ships:
                print(f'\n{vars(ship)}')

        else:
            print(f'at most {MAX_SHIPS} ships! ')

    def sell_ship(self, id):
        if is_id_in_list_range(id, self.ships):
            ship_id = self.ships[id].id

            self.ships.pop(id)
            self.gold += int(self.game.ship_id_2_obj[ship_id].price / 2)
            print(f'sold ship  {id}, '
                  f'now gold: {self.gold}'
                  f'now ships: {self.ships}')
        else:
            print(f'ship id {id} not in range '
                  f'of current ships: {self.ships}')

    def repair(self):
        pass

    def remodel(self):
        pass

    def ______BAR____(self):
        pass

    def hire_mate(self, id):
        if len(self.mates) < MAX_MATES:
            new_mate = Mate(id)
            self.mates.append(new_mate)
            print(f'hired mate {id}, now mates: {self.mates}')
        else:
            print(f'at most {MAX_MATES} mates! ')

    def fire_mate(self, id):
        if is_id_in_list_range(id, self.mates):
            self.mates.pop(id)
            print(f'fired mate {id}, '
                  f'now mates: {self.mates}')
        else:
            print(f'mate id {id} not in range '
                  f'of current ships: {self.mates}')

    def recruit_crew(self):
        pass

    def dismiss_crew(self):
        pass

    def investigate(self):
        pass


    def ______HARBOR____(self):
        pass

    def sail(self):
        pass

    def load_supply(self):
        pass

    def unload_supply(self):
        pass

    def ____MENU_FUNCS____(self):
        pass

    def ______SHIPS______(self):
        pass

    def fleet_info(self):
        pass

    def ship_info(self):
        pass

    def swap_ships(self):
        pass

    def ______MATES______(self):
        pass

    def admiral_info(self):
        pass

    def mate_info(self):
        pass

    def ______ITEMS______(self):
        pass

    def ______CMDS______(self):
        pass

    def search_for_discovery(self, id):
        dis = self.game.discovery_id_2_obj[id]
        if are_two_pos_the_same(self.pos, Pos(dis.x, dis.y)):
            self.found_discoveries_ids_set.add(dis.id)
            print(f'found {dis.name} at {dis.latitude} {dis.longitude}')
            print(f'{dis.description}')
            print(f'\n')
        else:
            print(f'can not find anything!')

    def enter_port(self, id):
        if id in self.game.port_id_2_obj:
            self.in_port_id = id
            print(f'\n#### entered port {id} ####')
            port = self.game.port_id_2_obj[id]

            self.in_port = port
            print(f'entered port {port.name} at {port.x} {port.y}')
            print(f'economy: {port.economy}, industry: {port.industry}')
        else:
            print(f'port id not in dict ')

    def enter_building(self, id):
        now_port = self.game.port_id_2_obj[self.in_port_id]
        type = BUILDING_ID_2_TYPE[id]

        # if port has this bd
        if now_port.buildings and str(id) in now_port.buildings:
            bd_x = now_port.buildings[str(id)]['x']
            bd_y = now_port.buildings[str(id)]['y']

            print(f'    entered {type} at {bd_x}, {bd_y} at {now_port.name}')

            self.in_building_id = id

        # else
        else:
            f'can not find {type} at {now_port.name} '



    def ______OPTIONS______(self):
        pass

    def ______ITEMS______(self):
        pass

class NPC(Role):
    pass

class Player(Role):
    pass


