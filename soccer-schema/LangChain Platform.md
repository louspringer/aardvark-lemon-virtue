```python
# user="louspringer",
# account='CFCLGQP-HQB93436',
# private_key_file='/home/lou/snow-keys/rsa_key.p8',
# warehouse="PRD_ALV_WAREHOUSE",
# database="PRD_ALV",        
# schema='QUERY_LINKEDIN',
# role='ALV_PROD_ROLE',
import openai
import snowflake.connector
from snowflake.snowpark import Session
import os
import pandas as pd
pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1000)

import json
import boto3
from dotenv import load_dotenv
import os
load_dotenv()

class SnowflakeJDBCExample:
    def __init__(self):
        self.account = "CFCLGQP-HQB93436"
        self.user = "louspringer"
        self.private_key_path = "/home/lou/snow-keys/rsa_key.p8"
        self.role = "ALV_PROD_ROLE"
        self.warehouse = "PRD_ALV_WAREHOUSE"
        self.database = "PRD_ALV"
        self.schema = "QUERY_LINKEDIN"

    def connect(self):
        try:
            # Establish the connection
            conn = snowflake.connector.connect(
                account=self.account,
                user=self.user,
                private_key_file=self.private_key_path,
                role=self.role,
                warehouse=self.warehouse,
                database=self.database,
                schema=self.schema
            )
            print("Connection successful!")
            # Use the connection (for example, execute a query)
            # cursor = conn.cursor()
            # cursor.execute("SELECT CURRENT_TIMESTAMP()")
            # for row in cursor:
            #     print(row)
        except Exception as e:
            print(f"An error occurred: {e}")

if __name__ == "__main__":
    example = SnowflakeJDBCExample()
    example.connect()
```


    ---------------------------------------------------------------------------

    ModuleNotFoundError                       Traceback (most recent call last)

    Cell In[1], line 8
          1 # user="louspringer",
          2 # account='CFCLGQP-HQB93436',
          3 # private_key_file='/home/lou/snow-keys/rsa_key.p8',
       (...)
          6 # schema='QUERY_LINKEDIN',
          7 # role='ALV_PROD_ROLE',
    ----> 8 import openai
          9 import snowflake.connector
         10 from snowflake.snowpark import Session


    ModuleNotFoundError: No module named 'openai'



```python
from langchain import OpenAI, SQLDatabase
from snowflake.snowpark import Session
from langchain.chains import create_sql_query_chain
```


```python
from snowflake.sqlalchemy import URL
from sqlalchemy import create_engine

from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives.asymmetric import dsa
from cryptography.hazmat.primitives import serialization

with open("/home/lou/snow-keys/rsa_key.p8", "rb") as key:
    p_key= serialization.load_pem_private_key(
        key.read(),
        password=None,
        backend=default_backend()
    )

pkb = p_key.private_bytes(
    encoding=serialization.Encoding.DER,
    format=serialization.PrivateFormat.PKCS8,
    encryption_algorithm=serialization.NoEncryption())

# user="louspringer",
# account='CFCLGQP-HQB93436',
# private_key_file='/home/lou/snow-keys/rsa_key.p8',


engine = create_engine(URL(
    account='CFCLGQP-HQB93436',
    user='louspringer',
    warehouse="PRD_ALV_WAREHOUSE",
    database="PRD_ALV",        
    schema='QUERY_LINKEDIN',
    role='ALV_PROD_ROLE',    
    ),
    connect_args={
        'private_key': pkb,
        },
    )
db = SQLDatabase(engine)
```


```python
# db = SQLDatabase.from_uri(snowflake_url,sample_rows_in_table_info=1, include_tables=['orders','locations'])

# we can see what information is passed to the LLM regarding the database
print(db.table_info)

```


```python
aws_access_key_id = os.getenv('aws_access_key_id') 
aws_secret_access_key = os.getenv('aws_secret_access_key')
aws_region = os.getenv('aws_region')
openai_api_key = os.getenv('openai_api_key')

region_name = os.getenv('aws_region')  # e.g., "us-west-2"
secret_name = "openai-api-key"
secret_value = openai_api_key
```


```python
# Usage example

# Initialize OpenAI with the retrieved API key
openai.api_key = openai_api_key

# Example usage of OpenAI with the API key using the updated API

response = openai.chat.completions.create(
    model="gpt-3.5-turbo",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Hello!"}
    ]
)

print(response.choices[0].message.content)
```


```python
response.choices[0].message.content
```


```python
response
```


```python
response = openai.chat.completions.create(
  model="gpt-3.5-turbo",
  messages=[
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "Who won the world series in 2020?"},
    {"role": "assistant", "content": "The Los Angeles Dodgers won the World Series in 2020."},
    {"role": "user", "content": "Where was it played?"}
  ]
)
response.choices[0].message.content
```


```python
from sqlalchemy import text

# with engine.connect() as connection:
#     result = connection.execute("SELECT SYSTEM$GET_SECRET('OPENAI_API_KEY')")
#     openai_api_key = result.scalar()


llm = OpenAI(temperature=0, openai_api_key=openai_api_key)
  
database_chain = create_sql_query_chain(llm,db)
```


```python
# user="louspringer",
# account='CFCLGQP-HQB93436',
# private_key_file='/home/lou/snow-keys/rsa_key.p8',
# warehouse="PRD_ALV_WAREHOUSE",
# database="PRD_ALV",        
# schema='QUERY_LINKEDIN',
# role='ALV_PROD_ROLE',
# ),
# connect_args={
#     'private_key': pkb,
#     },
# )

connection_parameters = {
    "account": "CFCLGQP-HQB93436",
    "user": "louspringer",
    "role": "ALV_PROD_ROLE",
    "private_key":pkb,
    "warehouse": "PRD_ALV_WAREHOUSE",
    "database": "PRD_ALV",
    "schema": "QUERY_LINKEDIN",
  }

session = Session.builder.configs(connection_parameters).create()
```


```python
prompt = "Show me the Orders Per City"

sql_query = database_chain.invoke({"question": prompt})

#we can visualize what sql query is generated by the LLM
print(sql_query)

session.sql(sql_query).show()
```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```
