import asyncio
import aioconsole


async def send_co(reader, writer):
    msgs = [
        'login@test_name@test_pwd',
        'get_worlds',
        'get_pcs_in_world@2',
        # 'create_pc@my_pc',
        'enter_world_as_pc@17',
        #
        'move_to@33@66',
        'move_to@33@66',
        'move_to@33@66',
        'lv_up',

        'logout'
    ]

    for msg in msgs:
    # while True:
    #     msg = await aioconsole.ainput()
        # send

        await asyncio.sleep(0.5)
        print(f'\n###### Sent: {msg}')
        writer.write(msg.encode())
        await writer.drain()


async def recv_co(reader, writer):
    while True:
        # recv
        data = await reader.read(1000)
        print(f'XXXXXX Got: {data.decode()!r}')

        # exit if got ''
        if not data:
            exit()


async def main():
    # conn
    reader, writer = await asyncio.open_connection(
        '127.0.0.1', 8888)

    # Schedule three calls *concurrently*:
    await asyncio.gather(
        send_co(reader, writer),
        recv_co(reader, writer),
    )

if __name__ == '__main__':
    asyncio.run(main())