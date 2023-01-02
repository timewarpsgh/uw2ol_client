from enum import Enum, auto
from dataclasses import dataclass


class PacketType(Enum):

    C_CREATE_ACCOUNT = auto()
    S_CREATE_ACCOUNT_RESP = auto()

    C_LOGIN = auto()
    S_LOGIN_RESP = auto()


class Packet:
    pass


@dataclass
class C_CREATE_ACCOUNT(Packet):
    account: str
    password: str


@dataclass
class S_CREATE_ACCOUNT_RESP(Packet):
    error_code: int
    error_reason: str


@dataclass
class C_LOGIN(Packet):
    account: str
    password: str


@dataclass
class S_LOGIN_RESP(Packet):
    error_code: int
    error_reason: str


def main():
    print(PacketType.C_LOGIN.value)
    print(type(PacketType.S_LOGIN_RESP.value))

    print(PacketType(2))

    packet = S_LOGIN_RESP(error_code=0, error_reason='xxx')
    print(type(packet).__name__)


if __name__ == '__main__':
    main()