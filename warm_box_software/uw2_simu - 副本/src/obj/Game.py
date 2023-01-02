import json

from obj.Player import Player, NPC
# from obj.Discovery import Discovery
# from obj.Port import Port

from data.models import connect_to_db
from data.models import Discovery, Port, Industry, Ship, Economy, Commodity

class Game:

    def __init__(self):
        print('######### init game')

        # connect to data db
        self.session_to_data_db = connect_to_db()

        # init discoveries
        self.discovery_id_2_obj = self.__init_discoveries()

        # init ports
        self.port_id_2_obj = self.__init_ports()

        # init industries
        self.industry_id_2_obj = self.__init_industries()

        # init ships
        self.ship_id_2_obj = self.__init_ships()

        # init economies
        self.economy_id_2_obj = self.__init_economies()

        # init commodities
        self.commodity_id_2_obj = self.__init_commodities()

        # init player
        print(f'#### __init player')
        self.player = Player(self, 1, 'Lin')

        # init npcs
        self.npc_id_2_obj = self.__init_npcs()

        # close connection to data db
        self.session_to_data_db.close()

    def __init_discoveries(self):
        print(f'#### __init_discoveries')
        # find all discoveries in db
        discoveries = self.session_to_data_db.query(Discovery).all()

        # set discovery_id_2_obj
        discovery_id_2_obj = {}
        for dis in discoveries:
            discovery_id_2_obj[dis.id] = dis
        return discovery_id_2_obj

    def __init_ports(self):
        print('#### __init_ports')
        # find all ports in db
        ports = self.session_to_data_db.query(Port).all()

        # set port_id_2_obj
        port_id_2_obj = {}
        for port in ports:
            # turn these json fields back
            port.allegiances = json.loads(port.allegiances)
            port.itemShop = json.loads(port.itemShop)
            port.buildings = json.loads(port.buildings)
            port.specialty = json.loads(port.specialty) if port.specialty else None

            # set id_2_obj
            port_id_2_obj[port.id] = port

        return port_id_2_obj

    def __reconnect_to_db(self):
        self.session_to_data_db.close()
        self.session_to_data_db = connect_to_db()

    def __init_industries(self):
        print('#### __init_industries')
        # reconnect (must do this)
        self.__reconnect_to_db()

        # find all industries in db
        industries = self.session_to_data_db.query(Industry).all()

        # set industry_id_2_obj
        industry_id_2_obj = {}
        for industry in industries:
            # turn these json fields back
            industry.available_ships_ids = json.loads(industry.available_ships_ids)

            # set id_2_obj
            industry_id_2_obj[industry.id] = industry

        return industry_id_2_obj

    def __init_economies(self):
        print('#### __init_economies')
        # reconnect (must do this)
        self.__reconnect_to_db()

        # find all industries in db
        economies = self.session_to_data_db.query(Economy).all()

        # set industry_id_2_obj
        economy_id_2_obj = {}
        for economy in economies:
            # turn these json fields back
            economy.available_commodities_ids = json.loads(economy.available_commodities_ids)

            # set id_2_obj
            economy_id_2_obj[economy.id] = economy

        return economy_id_2_obj

    def __init_ships(self):
        self.__reconnect_to_db()

        # find all industries in db
        ships = self.session_to_data_db.query(Ship).all()

        # set industry_id_2_obj
        ship_id_2_obj = {}
        for ship in ships:
            # set id_2_obj
            ship_id_2_obj[ship.id] = ship

        return ship_id_2_obj

    def __init_commodities(self):
        self.__reconnect_to_db()

        # find all industries in db
        commodities = self.session_to_data_db.query(Commodity).all()

        # set industry_id_2_obj
        commodity_id_2_obj = {}
        for commodity in commodities:
            # turn these json fields back
            commodity.buy_price = json.loads(commodity.buy_price)
            commodity.sell_price = json.loads(commodity.sell_price)


            # set id_2_obj
            commodity_id_2_obj[commodity.id] = commodity

        return commodity_id_2_obj

    def __init_npcs(self):
        print('#### __init_npcs')
        npc_id_2_obj = {}
        for i in range(2):
            npc = NPC(self, i, f'npc{i}')
            npc_id_2_obj[i] = npc
        return npc_id_2_obj

    def run(self):
        print(f'\n######### run game')
        self.__discover_things()
        self.__enter_ports_and_see_available_things()
        self.__loop_trade_between_two_ports()
        self.__buy_ships_and_hire_mates()
        self.__defeat_npcs()

    def __discover_things(self):
        print(f'#### __discover_things')
        for id, dis in self.discovery_id_2_obj.items():
            self.player.move_to(dis.x, dis.y)
            self.player.search_for_discovery(id)

        print(f'at the end, player {self.player.name} found the following discoveries:')
        print(self.player.found_discoveries_ids_set)

    def __enter_ports_and_see_available_things(self):
        print(f'#### __enter_ports_and_trade_things')
        # for each port
        for id, port in self.port_id_2_obj.items():
            # enter port
            self.player.enter_port(id)

            # enter each bd
            print(f'\n  #### enter each bd')
            for i in range(1, 13):
                self.player.enter_building(i)

            # show available ships
            self.____show_available_ships_in_port(port)

            # show available commodities
            self.____show_available_commodities_in_port(port)

            # show available specialty
            self.____show_available_specialty_in_port(port)

    def ____show_available_ships_in_port(self, port):
        if port.industryId or port.industryId == 0:
            industry = self.industry_id_2_obj[port.industryId]
            print(f'\n  ##### available_ships_ids: {industry.available_ships_ids}')
            for ship_id in industry.available_ships_ids:
                ship = self.ship_id_2_obj[ship_id]
                print(f'    name: {ship.name}   price: {ship.price}')
        else:
            print(f'this port has no industry id')

    def ____show_available_commodities_in_port(self, port):
        if port.economyId or port.economyId == 0:
            economy = self.economy_id_2_obj[port.economyId]
            print(f'\n  ##### available_commodities_ids: {economy.available_commodities_ids}')
            for commodity_id in economy.available_commodities_ids:
                commodity = self.commodity_id_2_obj[commodity_id]
                print(f'    name: {commodity.name}   buy_price: {commodity.buy_price[str(port.economyId)]}  '
                      f'sell_price: {commodity.sell_price[str(port.economyId)]}')
        else:
            print(f'this port has no economy id')

    def ____show_available_specialty_in_port(self, port):
        if port.specialty:
            print(f'\n  ##### available_specialty: {port.specialty}')
            for com_id, price in port.specialty.items():
                commodity = self.commodity_id_2_obj[int(com_id)]
                print(f'    specialty name: {commodity.name}  buy_price: {price} ')

        else:
            print(f'this port has no specialty')

    def __loop_trade_between_two_ports(self):

        # run n times
        for i in range(10):

            # buy glass_beads in amsterdam(special goods) (marseille normal goods)
            self.player.enter_port(34)
            self.____show_available_commodities_in_port(self.player.in_port)
            for ship_id, ship in enumerate(self.player.ships):
                self.player.buy_commodity(41, 100, ship_id)

            # sell in mosanbic
            self.player.enter_port(71)
            for ship_id, ship in enumerate(self.player.ships):
                self.player.sell_commodity(41, 100, ship_id)



    def __buy_ships_and_hire_mates(self):
        print('#### __buy_ships_and_hire_mates')

        for i in range(10):
            self.player.buy_ship(11)
        for i in range(11):
            self.player.sell_ship(1)

        # for i in range(20):
        #     self.player.hire_mate(i)
        # for i in range(3):
        #     self.player.fire_mate(i)

    def __defeat_npcs(self):
        print(f'#### __defeat_npcs')
        for id, npc in self.npc_id_2_obj.items():
            self.player.fight_with_npc(id)