from data.scalar import MAX_COMMODITY_TYPE_IN_SHIP

class Ship:
    def __init__(self, id, game):
        # get model_ship
        model_ship = game.ship_id_2_obj[id]


        self.id = model_ship.id

        self.name = model_ship.name

        # durability
        self.max_hp = model_ship.durability
        self.now_hp = model_ship.durability

        self.tacking = model_ship.tacking
        self.power = model_ship.power

        self.capacity = model_ship.capacity
        self.max_guns = model_ship.max_guns
        self.min_crew = model_ship.min_crew
        self.max_crew = model_ship.max_crew


        # dict
        self.commodity_id_2_cnt = {}


    def __calc_all_space_taken_by_commodities(self):
        taken_space = 0
        for cnt in self.commodity_id_2_cnt.values():
            taken_space += cnt
        return taken_space

    def __calc_left_space(self):
        space_taken_by_commodities = self.__calc_all_space_taken_by_commodities()
        left_space = self.capacity - space_taken_by_commodities
        return left_space

    def __load_commodity_if_max_types_not_reached(self, id, cnt):
        """returns T/F"""
        # if new
        if id not in self.commodity_id_2_cnt:
            print(f'commodity id {id} not in {self.commodity_id_2_cnt}')
            space_left = self.__calc_left_space()
            if space_left >= cnt:
                self.commodity_id_2_cnt[id] = cnt
                return True
            else:
                print('not enough space left')
                return False
        # else
        else:
            space_left = self.__calc_left_space()
            if space_left >= cnt:
                self.commodity_id_2_cnt[id] += cnt
                return True
            else:
                print('not enough space left')
                return False

    def load_commodity(self, id, cnt):
        """returns T/F"""
        # if max types reached
        if len(self.commodity_id_2_cnt.keys()) >= MAX_COMMODITY_TYPE_IN_SHIP:
            print(f'can load at most {MAX_COMMODITY_TYPE_IN_SHIP} types'
                  f'of commodity in one ship')
            return False

        # else
        else:
            return self.__load_commodity_if_max_types_not_reached(id, cnt)

    def unload_commodity(self, id, cnt):
        # if com in ship
        if id in self.commodity_id_2_cnt:
            # if cnt to sell < available
            if cnt < self.commodity_id_2_cnt[id]:
                self.commodity_id_2_cnt[id] -= cnt
                return True

            # elif cnt == available
            elif cnt == self.commodity_id_2_cnt[id]:
                print(f'cnt to sell == available, deleting key in dict')
                del self.commodity_id_2_cnt[id]
                return True

            # else cnt > availalbe
            else:
                print(f'sell cnt > availalbe, returning none')
                return False

        # esle
        else:
            print(f'this ship has no commodity {id} in it')
            return False

    def shoot_ship(self, npc, ship_index):
        print(f'my ship {self.name} shot npc ship {ship_index} ')

        target_ship = npc.ships[ship_index]
        target_ship.now_hp -= 10

        print(f'target_ship {ship_index} now_hp: {target_ship.now_hp}')

        # ret is_target_ship_dead
        if target_ship.now_hp <= 0:
            is_target_ship_dead = True
        else:
            is_target_ship_dead = False

        return is_target_ship_dead