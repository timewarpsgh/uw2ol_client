from obj.Pos import Pos

class Discovery:
    def __init__(self, id):
        self.id = id

        self.pos = Pos(id, id)
        self.name = f'village name {id}'
        self.description = f'village description {id}'
        self.image = f'village image {id}'
