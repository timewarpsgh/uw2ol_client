import time
import asyncio
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor

import sys
import json
import pickle


sys.path.append(r'D:\DATA\code\python\uw2_simu\src\data')

from models import connect_to_db, \
    Account, World, PC

from role import Role
from aoi_mgr import AoiMgr

from role import \
    SECS_TO_THINK_IN_BATTLE, MUST_MOVE_BEFORE_SECS


EXECUTOR = ThreadPoolExecutor()
CMDS_IN_ROLE_DICT = Role.__dict__
class SmallServer:
    def __init__(self, server, reader, writer):
        self.client_addr = None
        self.server = server
        self.reader = reader
        self.writer = writer

        self.client_account_id = None
        self.client_world_id = None
        self.client_pc_id = None
        self.role = None


    def send_to_this_client(self, pc_id, msg):
        small_server = self.server.pc_id_2_small_server[pc_id]
        small_server.send_to_client(msg)

    def send_to_client(self, msg):
        print(f'\n###### Sent: {msg[:20]}')
        self.writer.write(msg.encode())
        # await self.writer.drain()

    def send_to_other_clients(self, msg):
        """other clients means nearby clients"""
        # get_nearby_roles
        role_id_2_ins = self.server.aoi_mgr.get_nearby_roles(self.role)

        for role_id in role_id_2_ins.keys():
            if role_id == self.client_pc_id:
                continue
            small_server = self.server.pc_id_2_small_server[role_id]
            small_server.send_to_client(msg)

    def send_to_other_non_target_clients(self, msg):
        """other clients means nearby clients"""
        # get_nearby_roles
        role_id_2_ins = self.server.aoi_mgr.get_nearby_roles(self.role)

        for role_id in role_id_2_ins.keys():
            if role_id == self.client_pc_id or role_id == self.role.target_role.pc_id:
                continue
            small_server = self.server.pc_id_2_small_server[role_id]
            small_server.send_to_client(msg)

    def parse_msg(self, msg):
        split_items = msg.split('@')
        cmd = split_items[0]
        args = split_items[1:]

        # turn digits from str to int
        new_args = []
        for arg in args:
            if arg.isdigit():
                new_args.append(int(arg))
            else:
                new_args.append(arg)

        return cmd, new_args

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

    async def main(self):
        # just connected
        # add to server.client_addr_2_small_server
        addr = self.writer.get_extra_info('peername')
        self.server.client_addr_2_small_server[addr] = self
        print(f'\n#### !!new connection, now self.connected_clients: '
              f'{self.server.client_addr_2_small_server}')

        self.client_addr = addr

        # self.send_to_client('hello client:')

        # loop
        while True:
            # recv msg
            data = await self.reader.read(100)
            message = data.decode()
            print(f"\nXXXXXX Got: {message!r} from {addr!r}  at {datetime.now()}")
            cmd, args = self.parse_msg(message)

            # if cmds in role
            if cmd in CMDS_IN_ROLE_DICT:
                # run cmd in role
                self.send_to_other_clients(f'someone_ran_cmd:{pickle.dumps([self.client_pc_id, message])}')
                func = getattr(self.role, cmd)
                await self.run_cmd_in_role(func, args)

            # if other cmds
            else:
                # run in other threads
                loop = asyncio.get_event_loop()
                res = await loop.run_in_executor(EXECUTOR, getattr(CliMsgMgr, cmd), self, args)

                # this must run in main thread
                if cmd == 'logout':
                    break

                if cmd == 'enter_battle_with_target':
                    loop.create_task(CliMsgMgr.reduce_secs_left(self))

class CliMsgMgr:
    """
    handles msgs from client
    self is SmallServer
    these static methods were originally in SmallServer
    they run in thread_pool (not in the main thread)
    """

    def create_acnt(self: SmallServer, args):
        name = args[0]
        pwd = args[1]
        print(f'create_acnt {name} {pwd}')

        session = connect_to_db()
        account = session.query(Account).filter_by(name=name).first()
        if account:
            session.close()
            self.send_to_client(f'account name exists! failed!:')

        else:
            new_account = Account(name=name,
                                  pwd=pwd)
            session.add(new_account)
            session.commit()
            session.close()

            self.send_to_client(f'account created: {name}:')

    def login(self, args):
        name = args[0]
        pwd = args[1]
        print(f'login {name} {pwd}')

        session = connect_to_db()
        account = session.query(Account).filter_by(name=name). \
            filter_by(pwd=pwd).first()
        session.close()

        if account:
            self.client_account_id = account.id
            self.send_to_client(f'login successful:')
            print(f'self.client_account_id: {self.client_account_id}')
        else:
            self.send_to_client(f'login failed:')

        return '##login done!!!!'

    def logout(self, args):
        # set other roles to none
        self.role.pc_id_2_role = None

        # store role in db
        session = connect_to_db()
        pc = session.query(PC). \
            filter_by(id=self.client_pc_id). \
            first()
        pc.data = pickle.dumps(self.role)
        session.commit()
        session.close()

        # close conn
        print("Close the connection")
        self.writer.close()

        # send to others
        self.send_to_other_clients(f'someone_left_world:{pickle.dumps(self.client_pc_id)}')

        # delete from server.pc_id_2_role
        self.server.aoi_mgr.rm_role(self.role)
        del self.server.pc_id_2_role[self.client_pc_id]
        del self.server.pc_id_2_small_server[self.client_pc_id]

        # delete from server.client_addr_2_small_server
        del self.server.client_addr_2_small_server[self.client_addr]
        print(f'!! lost connection, now server.client_addr_2_small_server: '
              f'{self.server.client_addr_2_small_server}')

    def get_worlds(self, args):
        session = connect_to_db()
        worlds = session.query(World).all()
        session.close()

        msg = [f'{world.id}: {world.name} ' for world in worlds]
        self.send_to_client(f'{json.dumps(msg)}')

    def get_pcs_in_world(self, args):
        world_id = args[0]

        self.client_world_id = world_id

        session = connect_to_db()
        pcs = session.query(PC).\
            filter_by(world_id=world_id).\
            filter_by(account_id=self.client_account_id).\
            all()

        session.close()

        msg = [f'{pc.id}: {pc.name} ' for pc in pcs]
        self.send_to_client(f'{json.dumps(msg)}')

    def __replace_pc_in_db(self, pc_id, name):
        session = connect_to_db()
        pc = session.query(PC).filter_by(id=pc_id).first()

        new_role = Role(name, 1)
        new_role_in_bytes = pickle.dumps(new_role)

        pc.data = new_role_in_bytes
        session.commit()
        session.close()

    def create_pc(self, args):
        name = args[0]

        # for testing (replace role in db)
        if name == 'role_1':
            CliMsgMgr.__replace_pc_in_db(self, '49', name)
            self.send_to_client(f'new pc created: {name}')
            return
        elif name == 'role_2':
            CliMsgMgr.__replace_pc_in_db(self, '50', name)
            self.send_to_client(f'new pc created: {name}')
            return
        elif name == 'role_3':
            CliMsgMgr.__replace_pc_in_db(self, '51', name)
            self.send_to_client(f'new pc created: {name}')
            return

        # normal
        session = connect_to_db()

        new_role = Role(name, 1)
        new_role_in_bytes = pickle.dumps(new_role)

        new_pc = PC(name=name,
                    data=new_role_in_bytes,
                    world_id=self.client_world_id,
                    account_id=self.client_account_id)
        session.add(new_pc)
        session.commit()
        session.close()

        self.send_to_client(f'new pc created: {name}')

    def enter_world_as_pc(self, args):
        pc_id = args[0]

        session = connect_to_db()
        pc = session.query(PC).\
            filter_by(id=pc_id).\
            first()

        role = pickle.loads(pc.data)
        print(role.name)

        self.role = role
        self.client_pc_id = pc_id
        self.role.pc_id = pc_id

        session.close()

        self.server.pc_id_2_role[pc_id] = self.role
        self.server.aoi_mgr.add_role(self.role)
        self.server.pc_id_2_small_server[pc_id] = self

        role_id_2_ins = self.server.aoi_mgr.get_nearby_roles(self.role)
        self.role.pc_id_2_role = role_id_2_ins
        msg = [pc_id, role_id_2_ins]
        msg_in_bytes = pickle.dumps(msg)

        self.send_to_client(f'this_is_your_pc_data:{msg_in_bytes}')
        self.send_to_other_clients(f'someone_entered_world:{pickle.dumps([pc_id, role])}')

    def enter_port(self, args):
        id = args[0]

        # to prev nearby clients
        msg = f'someone_left_world:{pickle.dumps(self.client_pc_id)}'
        self.send_to_other_clients(msg)

        # aoi change map for role
        self.server.aoi_mgr.change_map_for_role(self.role, 'port', id)

        # role changes states
        self.role.in_port_id = id
        self.role.is_in_port = True
        self.role.is_at_sea = False
        self.role.is_in_battle = False

        # send msg to client
        role_id_2_ins = self.server.aoi_mgr.get_nearby_roles(self.role)
        msg = [self.client_pc_id, role_id_2_ins]
        msg_in_bytes = pickle.dumps(msg)

        msg = f'you_entered_port:{msg_in_bytes}'
        self.send_to_client(msg)

        # to now nearby clients
        msg = f'someone_entered_world:{pickle.dumps([self.client_pc_id, self.role])}'
        self.send_to_other_clients(msg)

    def sail(self, args):
        # to prev nearby clients
        msg = f'someone_left_world:{pickle.dumps(self.client_pc_id)}'
        self.send_to_other_clients(msg)

        # aoi change map for role
        self.server.aoi_mgr.change_map_for_role(self.role, 'sea')

        # role changes states
        self.role.is_at_sea = True
        self.role.is_in_port = False
        self.role.in_port_id = None
        self.role.is_in_battle = False

        # send msg to client
        role_id_2_ins = self.server.aoi_mgr.get_nearby_roles(self.role)
        msg = [self.client_pc_id, role_id_2_ins]
        msg_in_bytes = pickle.dumps(msg)

        msg = f'you_sailed:{msg_in_bytes}'
        self.send_to_client(msg)

        # to now nearby clients
        msg = f'someone_entered_world:{pickle.dumps([self.client_pc_id, self.role])}'
        self.send_to_other_clients(msg)

    def enter_battle_with_target(self, args):
        # if no target
        if not self.role.target_role:
            print(f'need a target to battle with!!')
            return

        # to prev nearby clients
        pc_ids = [self.client_pc_id, self.role.target_role.pc_id]
        msg = f'someones_left_world:{pickle.dumps(pc_ids)}'
        self.send_to_other_non_target_clients(msg)

        # aoi change map for role
        self.server.aoi_mgr.add_battle_map(self.client_pc_id)

        self.server.aoi_mgr.change_map_for_role(self.role, 'battle', self.client_pc_id)
        self.server.aoi_mgr.change_map_for_role(self.role.target_role,
                                                'battle', self.client_pc_id)

        # role changes states

        # self
        self.role.is_in_battle = True
        self.role.in_battle_id = self.client_pc_id
        self.role.is_at_sea = False
        self.role.is_in_port = False
        self.role.secs_left = SECS_TO_THINK_IN_BATTLE
        for _id, name in enumerate(self.role.ship_name_2_ins.keys()):
            ship = self.role.ship_name_2_ins[name]
            ship.x = 200
            ship.y = 100 + _id * 30

        # target
        t_role = self.role.target_role
        t_role.is_in_battle = True
        t_role.in_battle_id = self.role.pc_id
        t_role.is_at_sea = False
        t_role.is_in_port = False
        t_role.secs_left = 0

        t_role.target_role = self.role  # set my target's target to myself

        for _id, name in enumerate(self.role.target_role.ship_name_2_ins.keys()):
            ship = self.role.target_role.ship_name_2_ins[name]
            ship.x = 350
            ship.y = 100 + _id * 30

        # send msg to client
        role_id_2_ins = self.server.aoi_mgr.get_nearby_roles(self.role)
        msg = [self.role.pc_id, role_id_2_ins]
        msg_in_bytes = pickle.dumps(msg)

        msg = f'you_entered_battle:{msg_in_bytes}'
        self.send_to_client(msg)

        # send msg to other client
        msg = [self.role.target_role.pc_id, role_id_2_ins]
        msg_in_bytes = pickle.dumps(msg)

        msg = f'you_entered_battle:{msg_in_bytes}'
        self.send_to_other_clients(msg)

    async def reduce_secs_left(self):
        while self.role.is_in_battle:
            await asyncio.sleep(1)
            if self.role.secs_left > 0:
                self.role.secs_left -= 1
                print(f'self.role.secs_left: {self.role.secs_left}')

                if self.role.secs_left <= MUST_MOVE_BEFORE_SECS:
                    self.role.secs_left = 0
                    self.role.target_role.secs_left = SECS_TO_THINK_IN_BATTLE

            elif self.role.target_role.secs_left > 0:
                self.role.target_role.secs_left -= 1
                print(f'self.role.target_role.secs_left: {self.role.target_role.secs_left}')

                if self.role.target_role.secs_left <= MUST_MOVE_BEFORE_SECS:
                    self.role.target_role.secs_left = 0
                    self.role.secs_left = SECS_TO_THINK_IN_BATTLE

    def request_all_ships_operate(self, args):
        if self.role.secs_left >= MUST_MOVE_BEFORE_SECS:
            msg = f'you_can_do_all_ships_operate:'
            self.send_to_client(msg)
        else:
            msg = f'you can not do all_ships_operate:'
            print(msg)
            # self.send_to_other_clients(msg)


    def exit_battle(self, args):
        # aoi change map for role
        self.server.aoi_mgr.change_map_for_role(self.role, 'sea')
        self.server.aoi_mgr.change_map_for_role(self.role.target_role,
                                                'sea')
        self.server.aoi_mgr.rm_battle_map(self.client_pc_id,
                                          self.role.target_role.pc_id)

        # role changes states
        self.role.is_in_battle = False
        self.role.is_at_sea = True

        t_role = self.role.target_role
        t_role.is_in_battle = False
        t_role.is_at_sea = True

        # send msg to client and target client
        role_id_2_ins = self.server.aoi_mgr.get_nearby_roles(self.role)
        msg = [self.role.pc_id, role_id_2_ins]
        msg_in_bytes = pickle.dumps(msg)

        msg = f'you_exited_battle:{msg_in_bytes}'
        self.send_to_client(msg)
        self.send_to_this_client(self.role.target_role.pc_id, msg)

        # send msg to other non-target clients
        pc_id_2_role = {
            self.client_pc_id: self.role,
            self.role.target_role.pc_id: self.role.target_role,
        }
        msg = f'someones_entered_world:{pickle.dumps(pc_id_2_role)}'
        self.send_to_other_non_target_clients(msg)





class Server:

    def __init__(self):
        self.client_addr_2_small_server = {}
        self.pc_id_2_role = {}
        self.pc_id_2_small_server = {}
        self.aoi_mgr = AoiMgr()

    async def client_connected(self, reader, writer):
        """client connected"""

        small_server = SmallServer(self, reader, writer)
        await small_server.main()

    async def main(self):
        server = await asyncio.start_server(
            self.client_connected, '127.0.0.1', 8888)

        addrs = ', '.join(str(sock.getsockname()) for sock in server.sockets)
        print(f'Serving on {addrs}')

        async with server:
            await server.serve_forever()

def main():
    server = Server()
    asyncio.run(server.main())

if __name__ == '__main__':
    main()