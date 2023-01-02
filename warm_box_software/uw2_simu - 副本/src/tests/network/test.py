

class User:

    def __init__(self, name, age):
        self.__name = name
        self.__age = age

    def get_name(self):
        return self.__name





def main():
    user = User('lin chen', 31)
    name = user.get_name()
    print(name)
    print(user.name)


if __name__ == '__main__':
    main()