import os
import sys
import pygame
from pygame.locals import *
import asyncio
from role import Role

SCREEN_WIDTH = 600
SCREEN_HEIGHT = 400
HIDE_X = - 500
HIDE_Y = -500
FONT_SIZE = 16

YELLOW = (255, 255, 0)
RED = (255, 0, 0)


class SP(pygame.sprite.Sprite):

    def __init__(self):
        pygame.sprite.Sprite.__init__(self)

        self.image = None
        self.rect = None

    def change_img(self, img):
        self.image = img

    def move_to(self, x, y):
        self.rect = self.image.get_rect().move(x, y)


class BackGround(SP):

    def __init__(self, image, role, gui):
        SP.__init__(self)

        self.role = role
        self.gui = gui
        self.image = image
        self.rect = image.get_rect().move(0, 0)


class Player(SP):

    def __init__(self, image, gui, is_mine=False,
                 x=SCREEN_WIDTH // 2, y=SCREEN_HEIGHT // 2):
        SP.__init__(self)

        self.gui = gui
        self.is_mine = is_mine
        self.image = image
        self.rect = image.get_rect().move(x, y)


class ShipInBattle(SP):

    def __init__(self, gui, image, x, y):
        SP.__init__(self)

        self.gui = gui
        self.image = image
        self.rect = image.get_rect().move(x, y)

        self.x = x
        self.y = y


class CannonBall(SP):

    STEPS_TO_DEST = 4
    FRAMES_PER_STEP = 1


    def __init__(self, image, fr_x, fr_y, to_x, to_y):
        SP.__init__(self)

        self.image = image
        self.rect = image.get_rect().move(fr_x, fr_y)

        self.x = fr_x
        self.y = fr_y

        self.d_x = (to_x - fr_x) // CannonBall.STEPS_TO_DEST
        self.d_y = (to_y - fr_y) // CannonBall.STEPS_TO_DEST

        self.frame_cnt = 0
        self.steps_taken = 0

    def update(self):
        """move to dest and disappear"""
        self.frame_cnt += 1

        if self.frame_cnt % CannonBall.FRAMES_PER_STEP == 0:
            self.x += self.d_x
            self.y += self.d_y
            self.rect = self.image.get_rect().move(self.x, self.y)
            self.steps_taken += 1

            if self.steps_taken >= CannonBall.STEPS_TO_DEST:
                self.kill()


class DmgNum(SP):
    def __init__(self, font, number, x, y, color=YELLOW):
        SP.__init__(self)

        self.image = font.render(str(number), True, color)
        self.rect = self.image.get_rect()

        self.frames = [None] * 60
        scale = 3
        for i in range(len(self.frames)):
            scale -= 0.03
            self.frames[i] = pygame.transform.scale(
                self.image,
                (int(self.rect.width * scale),
                int(self.rect.height * scale)))
        self.frame_index = -1

        self.image = self.frames[-1]

        self.rect.x = x
        self.rect.y = y

        self.x_speed = 1.4
        self.y_speed = 3
        self.d_y = 0.15

    def update(self):
        if self.frame_index < len(self.frames) - 1:
            self.frame_index += 1
            self.image = self.frames[self.frame_index]

            self.rect.y -= self.y_speed
            self.y_speed -= self.d_y
            self.rect.x += self.x_speed
        else:
            self.kill()


class BattleTimer(SP):
    def __init__(self, client, font, number, x, y, color=YELLOW):
        SP.__init__(self)


        self.client = client
        self.image = font.render(str(number), True, color)
        self.rect = self.image.get_rect()

        self.frames = [None] * 60
        scale = 3
        for i in range(len(self.frames)):
            scale -= 0.03
            self.frames[i] = pygame.transform.scale(
                self.image,
                (int(self.rect.width * scale),
                 int(self.rect.height * scale)))
        self.frame_index = -1

        self.image = self.frames[-1]

        self.rect.x = x
        self.rect.y = y

        self.x_speed = 1.4
        self.y_speed = 3
        self.d_y = 0.15

    def update(self):
        if self.frame_index < len(self.frames) - 1:
            self.frame_index += 1
            self.image = self.frames[self.frame_index]

            self.rect.y -= self.y_speed
            self.y_speed -= self.d_y
            self.rect.x += self.x_speed
        else:
            self.kill()


class Hud(SP):
    def __init__(self, image):
        SP.__init__(self)

        self.image = image
        self.rect = image.get_rect().move(-20, -20)


class Controller:

    KEY_2_MSG = {
        's': 'move@s',
        'w': 'move@n',
        'a': 'move@w',
        'd': 'move@e',

        'i': 'enter_port@1',
        'o': 'sail',
        't': 'enter_port@2',


        'b': 'enter_battle_with_target',
        'n': 'request_all_ships_operate',
        'm': 'exit_battle',
    }

    def __init__(self, gui):
        self.gui = gui

    def handle_event(self, event):
        # key down
        if event.type == pygame.KEYDOWN:

            # escape
            if event.key == pygame.K_ESCAPE:
                sys.exit()

            # move
            elif chr(event.key) in Controller.KEY_2_MSG:
                msg = Controller.KEY_2_MSG[chr(event.key)]
                self.gui.send_msg_to_model(msg)




class GUI:

    def __init__(self, role=None, client=None):
        pygame.init()

        self.controller = Controller(self)

        # knows role and client
        self.role = role
        self.client = client

        self.__load_font()
        self.__load_images()
        self.__add_to_sprites()

        self.__load_sounds()

    def __load_font(self):
        self.font = pygame.font.SysFont("arial", FONT_SIZE)

    def __load_image(self, path_to_img, set_transparent=True):
        image = pygame.image.load(path_to_img).convert()

        if set_transparent:
            colorkey = image.get_at((0, 0))
            image.set_colorkey(colorkey, pygame.RLEACCEL)
            return image
        else:
            return image

    def __load_images(self):
        self.screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))

        # bg
        self.background = pygame.image.load(
            r'D:\DATA\back_up_drive\P\Python\Games\uw2ol'
            r'\assets\images\world_map\world_map_grids.png').convert()
        scale = 3
        size = self.background.get_size()
        size = (size[0] * scale, size[1] * scale)
        self.background = pygame.transform.scale(self.background, size)

        # port image
        self.port_image = self.__load_image(r'D:\DATA\code\python\uw2_simu\res\images\port.png')

        self.battle_image = self.__load_image(r'D:\DATA\back_up_drive\P\Python'
                                              r'\Games\uw2ol\assets\images\in_battle\battle.png')

        # player
        self.player = self.__load_image(r'D:\DATA\back_up_drive\P\Python\Games\uw2ol\assets\images\player\ship_at_sea.png')

        # hud
        self.hud = self.__load_image(r'D:\DATA\code\python\uw2_simu\res\images\hud.png')

        # cannon img
        self.cannon_img = self.__load_image(r'D:\DATA\code\python\uw2_simu\res\images\cannon.png')

    @staticmethod
    def __load_all_sounds(sounds_dict, directory, accept=('.ogg')):
        """loads all imgs in dir into image_container"""
        for sound in os.listdir(directory):
            name, ext = os.path.splitext(sound)
            if ext.lower() in accept:
                sounds_dict[name] = pygame.mixer.Sound(os.path.join(directory, sound))

    def __load_sounds(self):
        self.sounds = {}
        GUI.__load_all_sounds(self.sounds, r"D:\DATA\code\python\uw2_simu\res\sounds")

    def __add_to_sprites(self):
        # init self.sprites
        self.sprites = pygame.sprite.Group()

        # init bg and add to sprites
        self.background_sp = BackGround(self.background, self.role, self)
        self.sprites.add(self.background_sp)

        # init pc_id_2_sp
        self.pc_id_2_sp = {}

        # init my_ship_name_2_sp
        self.my_ship_name_2_sp = {}
        self.enemy_ship_name_2_sp = {}

        # init Hud
        self.hud_sp = Hud(self.hud)
        self.sprites.add(self.hud_sp)


    async def run(self):

        while 1:
            # handle events
            self.__handle_events()

            # change states
            self.__change_states()

            # draw
            self.__draw()

            # delay
            pygame.time.delay(50)
            await asyncio.sleep(0.01)

    def send_msg_to_model(self, msg):
        if self.client:
            self.client.gui_msgs_queue.append(msg)

    def __handle_events(self):
        """pass msg to queue"""
        for event in pygame.event.get():
            self.controller.handle_event(event)

    def __change_states(self):
        """update sprites"""
        self.sprites.update()

    def __draw(self):
        # clear screen
        self.screen.fill((0, 0, 0))

        # draw objs
        self.sprites.draw(self.screen)

        # show screen
        pygame.display.update()

        # print role
        if self.role:
            pass
        else:
            pass


class ModelMsgMgr:
    """self is GUI"""
    def mv_bg_to(self: GUI, x, y):
        self.background_sp.move_to(x, y)

    def change_bg_to(self, map):
        if map == 'port':
            self.background_sp.change_img(self.port_image)
        elif map == 'sea':
            self.background_sp.change_img(self.background)
        elif map == 'battle_field':
            self.background_sp.change_img(self.battle_image)

    def init_player_sp(self, pc_id):
        sp = Player(self.player, self, is_mine=True)
        self.player_sp = sp
        self.pc_id_2_sp[pc_id] = sp

        sp.add(self.sprites)

    def init_other_player_sp(self, pc_id, x, y):
        sp = Player(self.player, self, is_mine=False,
                    x=x + SCREEN_WIDTH // 2, y=y + SCREEN_HEIGHT // 2)

        self.pc_id_2_sp[pc_id] = sp
        sp.add(self.sprites)

    def mv_other_player_sp(self, pc_id, x, y):
        sp = self.pc_id_2_sp[pc_id]
        sp.move_to(x + SCREEN_WIDTH // 2,
                   y + SCREEN_HEIGHT // 2)

    def rm_other_player_sp(self, pc_id):
        sp = self.pc_id_2_sp[pc_id]
        sp.kill()
        del self.pc_id_2_sp[pc_id]

    def init_my_ship_in_battle(self, name, x, y):
        sp = ShipInBattle(self, self.player, x, y)
        self.my_ship_name_2_sp[name] = sp
        sp.add(self.sprites)

    def mv_my_ship_in_battle(self, name, x, y):
        sp = self.my_ship_name_2_sp[name]
        sp.move_to(x, y)

    def mv_enemy_ship_in_battle(self, name, x, y):
        sp = self.enemy_ship_name_2_sp[name]
        sp.move_to(x, y)

    def rm_my_ship_in_battle(self, name):
        self.my_ship_name_2_sp[name].kill()
        del self.my_ship_name_2_sp[name]

    def init_enemy_ship_in_battle(self, name, x, y):
        sp = ShipInBattle(self, self.player, x, y)
        self.enemy_ship_name_2_sp[name] = sp
        sp.add(self.sprites)

    def rm_enemy_ship_in_battle(self, name):
        self.enemy_ship_name_2_sp[name].kill()
        del self.enemy_ship_name_2_sp[name]

    def rm_all_ships_in_battle(self):
        my_ship_names = list(self.my_ship_name_2_sp.keys())
        for name in my_ship_names:
            ModelMsgMgr.rm_my_ship_in_battle(self, name)

        enemy_ship_names = list(self.enemy_ship_name_2_sp.keys())
        for name in enemy_ship_names:
            ModelMsgMgr.rm_enemy_ship_in_battle(self, name)

    def show_cannon_ball_from_to(self, fr_x, fr_y, to_x, to_y):
        sp = CannonBall(self.cannon_img, fr_x, fr_y, to_x, to_y)
        sp.add(self.sprites)

    def show_dmg_num_at(self, num, x, y):
        sp = DmgNum(self.font, num, x, y)
        sp.add(self.sprites)

    def play_sound(self, sound_name):
        self.sounds[sound_name].play()

    def show_wait_msg(self):
        self.show_dmg_num_at(10000, 200, 200)

    def show_battle_timer(self, secs):
        sp = BattleTimer(self.client, self.font, secs, 300, 300, RED)
        sp.add(self.sprites)


async def main():
    role = Role(name='Tom', lv=1)
    gui = GUI(role)
    await gui.run()


if __name__ == '__main__':
    asyncio.run(main())
