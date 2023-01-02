from role import Role


class Grid:
    """has role_id_2_ins"""
    def __init__(self):
        self.role_id_2_ins = {}

    def add_role(self, role):
        self.role_id_2_ins[role.pc_id] = role

        print(f'added role, now: {self.role_id_2_ins}')

    def rm_role(self, role):
        if role.pc_id in self.role_id_2_ins:
            del self.role_id_2_ins[role.pc_id]

        print(f'rmed role, now: {self.role_id_2_ins}')

    def get_role_id_2_ins(self):
        return self.role_id_2_ins


class Map:
    """has grids"""
    def __init__(self):
        self.grids = []

        only_grid = Grid()
        self.grids.append(only_grid)

    def add_role(self, role):
        self.grids[0].add_role(role)

    def rm_role(self, role):
        self.grids[0].rm_role(role)

    def change_grid_for_role(self):
        pass

    def get_nearby_roles(self, role):
        return self.grids[0].get_role_id_2_ins()


class SeaMap(Map):
    def __init__(self):
        Map.__init__(self)


class PortMap(Map):
    def __init__(self):
        Map.__init__(self)


class BattleMap(Map):
    """has only one grid"""
    def __init__(self):
        Map.__init__(self)


class AoiMgr:
    """has many maps, and roles are in grids in maps"""
    def __init__(self):
        self.sea_map = SeaMap()
        self.port_map_id_2_ins = {i: PortMap() for i in range(1, 10)}
        self.battle_map_id_ins = {}

    def add_role(self, role):
        """log in"""
        if role.is_at_sea:
            self.sea_map.add_role(role)
            print(f'added {role.name} to sea map')
        elif role.is_in_port:
            self.port_map_id_2_ins[role.in_port_id].add_role(role)
            print(f'added {role.name} to port map {role.in_port_id}')

    def rm_role(self, role):
        """log out"""
        if role.is_at_sea:
            self.sea_map.rm_role(role)

    def change_grid_for_role(self):
        """later"""
        pass

    def change_map_for_role(self, role, map_type, map_id=None):

        print(f'map_id: {map_id}')
        """map_type: sea/port/battle"""
        if map_type == 'sea':
            now_map = self.get_role_map(role)
            now_map.rm_role(role)

            tar_map = self.sea_map
            tar_map.add_role(role)

        elif map_type == 'port':
            now_map = self.get_role_map(role)
            now_map.rm_role(role)

            tar_map = self.port_map_id_2_ins[map_id]
            tar_map.add_role(role)

        elif map_type == 'battle':
            now_map = self.get_role_map(role)
            now_map.rm_role(role)

            tar_map = self.battle_map_id_ins[map_id]
            tar_map.add_role(role)

    def get_role_map(self, role):
        if role.is_at_sea:
            return self.sea_map
        elif role.is_in_port:
            return self.port_map_id_2_ins[role.in_port_id]
        elif role.is_in_battle:
            return self.battle_map_id_ins[role.in_battle_id]

    def get_role_grid(self):
        pass

    def get_nearby_roles(self, role):
        if role.is_at_sea:
            return self.sea_map.get_nearby_roles(role)
        elif role.is_in_port:
            return self.port_map_id_2_ins[role.in_port_id].get_nearby_roles(role)
        elif role.is_in_battle:
            return self.battle_map_id_ins[role.in_battle_id].get_nearby_roles(role)


    def add_battle_map(self, id):
        self.battle_map_id_ins[id] = BattleMap()

    def rm_battle_map(self, id_1, id_2):
        if id_1 in self.battle_map_id_ins:
            del self.battle_map_id_ins[id_1]
        else:
            del self.battle_map_id_ins[id_2]

def main():

    # init roles
    role1 = Role(name='alice', lv=1)
    role1.pc_id = 1
    role1.is_in_port = True
    role1.is_at_sea = False
    role1.in_port_id = 1

    role2 = Role(name='bob', lv=1)
    role2.pc_id = 2

    role3 = Role(name='cida', lv=1)
    role3.pc_id = 3

    # add roles
    aoi_mgr = AoiMgr()
    aoi_mgr.add_role(role1)
    aoi_mgr.add_role(role2)
    aoi_mgr.add_role(role3)

    aoi_mgr.change_map_for_role(role3, 'port', 3)

    assert len(aoi_mgr.sea_map.get_nearby_roles(role2)) == 1


if __name__ == '__main__':
    main()
    dict.keys()