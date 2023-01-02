class Pos:
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y

class Role:
    def __init__(self, name, lv):
        self.name = name
        self.lv = lv
        self.pos = Pos()

    def move_to(self, x, y):
        self.pos.x = x
        self.pos.y = y

    def lv_up(self):
        self.lv += 1