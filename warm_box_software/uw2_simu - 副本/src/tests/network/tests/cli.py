import asyncio
import pickle
import time

from multiprocessing import Pool

from role import Role

from concurrent.futures import ThreadPoolExecutor


EXECUTOR = ThreadPoolExecutor()
CLIENT_CNT = 1
CMDS_IN_ROLE_DICT = Role.__dict__

class Client(asyncio.Protocol):
    def __init__(self, on_con_lost):
        self.on_con_lost = on_con_lost

        self.pc = None
        self.pc_id_2_role = None
        self.npcs = None

    def parse_msg(self, msg):
        split_items = msg.split('@')
        cmd = split_items[0]
        args = split_items[1:]
        return cmd, args

    def run_cmd_in_role(self, func, args):
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
        else:
            print(f'!!!!!!!!! too many args !!!!!!!')

    def connection_made(self, transport):
        # define msgs to send
        msgs = ['login@test_name@test_pwd',
                'get_worlds',
                'get_pcs_in_world@2',
                # 'create_pc@my_pc',
                'enter_world_as_pc@17',

                'move_to@33@66',
                'move_to@33@66',
                'move_to@33@66',
                'lv_up',

                'logout'
                ]

        # for each msg
        for msg in msgs:
            # parse cmd
            cmd, args = self.parse_msg(msg)

            # if cmd in role
            if cmd in CMDS_IN_ROLE_DICT:
                func = getattr(self.pc, cmd)
                self.run_cmd_in_role(func, args)
                print(f'\nXXXXX Ran {cmd} with {args}')

            # send
            print(f'\n###### Sent: {msg}')
            transport.write(msg.encode())
            time.sleep(1)

    def data_received(self, data):
        print(f'Received: {data.decode()}')
        if data.decode().startswith('this is your pc data:'):
            print('detected pc data from server!!')
            ojb_bytes = data.decode()[21:]
            print(f'ojb_bytes: {ojb_bytes}')

            print(ojb_bytes)

            li = pickle.loads(eval(ojb_bytes))
            my_pc_id = li[0]
            pc_id_2_role = li[1]

            my_pc = pc_id_2_role[my_pc_id]

            print(my_pc)
            print(f'name: {my_pc.name}')
            print(f'lv: {my_pc.lv}')
            print(f'x: {my_pc.pos.x}')
            print(f'y: {my_pc.pos.y}')

            self.pc = my_pc
            self.pc_id_2_role = pc_id_2_role

            print(f'self.pc_id_2_role: {self.pc_id_2_role}')


    def connection_lost(self, exc):
        print('The server closed the connection')
        self.on_con_lost.set_result(True)


async def main():
    # Get a reference to the event loop as we plan to use
    # low-level APIs.
    loop = asyncio.get_running_loop()

    on_con_lost = loop.create_future()

    transport, protocol = await loop.create_connection(
        lambda: Client(on_con_lost),
        '127.0.0.1', 8888)

    # Wait until the protocol signals that the connection
    # is lost and close the transport.
    try:
        await on_con_lost
    finally:
        transport.close()

if __name__ == '__main__':
    asyncio.run(main())
