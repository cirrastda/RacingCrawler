import mysql.connector


class Db(object):
	cnx = None
	config = {}

	def __init__(self, config):
		self.config = config
		#self.connect()

	def is_number(self, s):
		try:
			float(s)
			return True
		except ValueError:
			return False
  	
	def connect2(self):
		config = self.config
		print(config)

	def connect(self):
		try:
			config = self.config
			print(config);

			self.cnx = mysql.connector.connect(**config)
			
			if (self.cnx.is_connected()) :
				db_Info = self.cnx.get_server_info()
				print("Connected to MySQL Server version", db_Info)
				cursor = self.cnx.cursor()
				cursor.execute("select database();")
				record = cursor.fetchone()
				print("You're connected to database: ", record)
		except Error as e:
			print("Error while connecting to MySQL", e)
		finally:
			if (self.cnx.is_connected()):
				cursor.close()
				#self.cnx.close()
				#print("MySQL self.cnx is closed")
				return self.cnx

	def query(self, statement, data=''):
		cursor = self.cnx.cursor(dictionary=True)
		cursor.execute(statement)
		result = cursor.fetchall()
		cursor.close
		#names = [i[0] for i in result]
		#print(names)
		return result

	def select(self, table, fields = [], conditions = {}, order = []):
		if (len(fields)==0):
			fields = ["*"];

		sql = "SELECT "
		i = 1;
		for field in fields:
			sql += field
			if i<len(fields):
				sql += ", "
			i += 1
		
		sql += " FROM "+table

		i = 0;
		if (len(conditions)>0):
			sql += " WHERE ";
			for cond in conditions:
				if i>0:
					sql += " AND "
				if (self.is_number(conditions[cond])):
					sql += cond+" = "+str(conditions[cond])
				else:
					sql += cond+" = '"+conditions[cond]+"' "
				i += 1
		if (len(order)>0):
			sql += " ORDER BY ";
			for iOrder in order:
				sql = order
		print(sql);
		return self.query(sql)

	def insert(self, table, data):
		sql = "INSERT INTO "+table+"("
		fields = ""
		values = "VALUES("
		total = len(data)
		i = 1
		for item in data:
			fields += item
			if (i<total):
				fields = fields + ", "
			if (self.is_number(data[item])):
				values = values + str(data[item])
			else:
				values = values + "'"+data[item]+"'"
			if (i<total):
				values += ", "
			i+=1
		fields += ")"
		values += ")"
		sql = sql+fields+" "+values
		return self.execute(sql)

	def insert_if_not_exists(self, table, data, condition):
		result = self.select(table, ["COUNT(0) AS conta"], condition);
		result = result[0];
		if (result['conta']<=0):
			res = self.insert(table, data);
			if not res:
				return False;

		result = self.select(table, ['id'], condition)
		print(condition)
		print(result)
		result = result[0]
		return result['id']

	def execute(self, command):
		db_cursor = self.cnx.cursor()
		try:
			db_cursor.execute(command)
		except Error as e:
			print("Error while connecting to MySQL", e)
			ret = False
		else:
			self.cnx.commit()
			ret = True
		finally:
			return ret

	def close(self):
		self.cnx.close()
		return True