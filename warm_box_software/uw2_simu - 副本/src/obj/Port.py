from obj.Pos import Pos

class Port:
    def __init__(self, id):
        self.id = id

        self.pos = Pos(id, id)
        self.name = f'port name {id}'
        self.description = f'port description {id}'
        self.image = f'port image {id}'
