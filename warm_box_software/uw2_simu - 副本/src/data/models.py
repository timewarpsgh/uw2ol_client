from sqlalchemy import Column, Integer, String, BLOB, create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

import json

PATH_TO_DB = r'D:\DATA\code\python\uw2_simu\res\data.data'

Base = declarative_base()

class Discovery(Base):
	# table
	__tablename__ = 'discovery'

	# id
	id = Column(Integer, primary_key=True, autoincrement=True)

	# text and image
	name = Column(String(20))
	description = Column(String(200))
	image_x = Column(Integer)
	image_y = Column(Integer)

	# pos
	x = Column(Integer)
	y = Column(Integer)
	latitude = Column(String(8))
	longitude = Column(String(8))

class Port(Base):
	# table
	__tablename__ = 'port'

	# id
	id = Column(Integer, primary_key=True, autoincrement=True)

	# simple fields
	name = Column(String(20))

	regionId = Column(Integer)
	x = Column(Integer)
	y = Column(Integer)
	tileset = Column(Integer)

	economy = Column(Integer)
	economyId = Column(Integer)

	industry = Column(Integer)
	industryId = Column(Integer)

	# json fields
	allegiances = Column(String(40))
	itemShop = Column(String(40))
	buildings = Column(String(200))
	specialty = Column(String(20))

class Industry(Base):
	# table
	__tablename__ = 'industry'

	# id
	id = Column(Integer, primary_key=True)

	# simple fields
	name = Column(String(20))

	# json fields
	available_ships_ids = Column(String(100))

class Ship(Base):
	# table
	__tablename__ = 'ship'

	# id
	id = Column(Integer, primary_key=True, autoincrement=True)

	# simple fields
	name = Column(String(20))

	durability = Column(Integer)
	tacking = Column(Integer)
	power = Column(Integer)

	capacity = Column(Integer)
	max_guns = Column(Integer)
	min_crew = Column(Integer)
	max_crew = Column(Integer)

	price = Column(Integer)

class Economy(Base):
	# table
	__tablename__ = 'economy'

	# id
	id = Column(Integer, primary_key=True)

	# simple fields
	name = Column(String(20))

	# json fields
	available_commodities_ids = Column(String(100))

class Commodity(Base):
	# table
	__tablename__ = 'commodity'

	# id
	id = Column(Integer, primary_key=True)

	# simple fields
	name = Column(String(20))

	# json fields (economy_id_2_price)
	buy_price = Column(String(100))
	sell_price = Column(String(100))


class Mate(Base):
	# table
	__tablename__ = 'mate'

	# id
	id = Column(Integer, primary_key=True, autoincrement=True)

	# text and image
	name = Column(String(20))
	nation = Column(String(20))
	lv = Column(Integer)
	image_x = Column(Integer)
	image_y = Column(Integer)

	# pos
	leadership = Column(Integer)
	seamanship = Column(Integer)
	knowledge = Column(Integer)
	intuition = Column(Integer)
	courage = Column(Integer)
	swordplay = Column(Integer)
	luck = Column(Integer)

	accounting = Column(Integer)
	gunnery = Column(Integer)
	navigation = Column(Integer)


class Account(Base):
	# table
	__tablename__ = 'account'

	# id
	id = Column(Integer, primary_key=True, autoincrement=True)

	name = Column(String(20))
	pwd = Column(String(20))


class World(Base):
	# table
	__tablename__ = 'world'

	# id
	id = Column(Integer, primary_key=True, autoincrement=True)

	name = Column(String(20))


class PC(Base):
	# table
	__tablename__ = 'PC'

	# id
	id = Column(Integer, primary_key=True, autoincrement=True)

	name = Column(String(20))
	data = Column(BLOB)
	world_id = Column(Integer)
	account_id = Column(Integer)

def connect_to_db():
	# ceate all above tables if not there yet
	engine = create_engine(f'sqlite:///{PATH_TO_DB}')
	Base.metadata.create_all(engine, checkfirst=True)

	# connect to table
	Session = sessionmaker(bind=engine)
	session = Session()

	return session

if __name__ == '__main__':
	# from hash_special_goods import hash_special_goods

	# connect_to_table
	session = connect_to_db()
	session.close()
	#
	#
	#
	# session.commit()

	pass