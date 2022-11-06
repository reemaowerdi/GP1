#!/usr/bin/env python
# coding: utf-8

# In[1]:


import firebase_admin
from firebase_admin import db
from firebase_admin import credentials
from flask import Flask, request
from firebase_admin import firestore

databaseURL ='https://read-me-a-story3-default-rtdb.firebaseio.com/'

cred_object = credentials.Certificate("./config/firebase.json")
default_app = firebase_admin.initialize_app(cred_object, {
    'databaseURL':databaseURL ,
})


# In[2]:


HTML_TEXT = '''

    <form method="post" style="border:1px solid black;width: 40%; padding: 4%; margin: 5%;" action="#" style="margin: 40px;">
       
     
       
            
        <label for='title' style="font-size: 30px;font-weight: 1000;">TITLE: </label> 
        <input name="title"  type="text" id='title' style="font-size: 15px;font-weight: 600;"></input>    
        
        <br /><br /><br /><br /><br /><br />
        <label style="font-size: 30px;font-weight: 800;" for='story'>CONTENT: </label>
        
       <textarea name='content' style="font-size: 20px;font-weight: 1000;"></textarea> 
    
       <br /><br /><br /><br /><br /><br />
       <label for='moral' style="font-size: 30px;font-weight: 1000;">MORAL: </label>
       
      <input name='moral' id='moral' style="font-size: 20px;font-weight: 800;"></input> <br /><br /><br />
    
    <input style="height:50px;width:150px; font-size: 20px;margin-left: 25%;" type="submit" >
        </form>
    
    
    '''
    
# In[3]:

# import torch
# from transformers import TrainingArguments, Trainer
# from transformers import  AutoModelForSequenceClassification, AutoTokenizer ,BertTokenizer, BertForSequenceClassification
# from transformers import EarlyStoppingCallback
# import numpy as np
# import pandas as pd

# # In[4]:
# # Create torch dataset
# class Dataset(torch.utils.data.Dataset):
#     def __init__(self, encodings, labels=None):
#         self.encodings = encodings
#         self.labels = labels

#     def __getitem__(self, idx):
#         item = {key: torch.tensor(val[idx]) for key, val in self.encodings.items()}
#         if self.labels:
#             item["labels"] = torch.tensor(self.labels[idx])
#         return item

#     def __len__(self):
#         return len(self.encodings["input_ids"])

# In[5]:
# def prediction(self):
#   self = ['']
#   tokenizer = AutoTokenizer.from_pretrained("roberta-base")
#   X_test_tokenized = tokenizer(self, padding=True, truncation=True, max_length=512)

#   # Create torch da

#   test_dataset = Dataset(X_test_tokenized)

#   # Load trained model
#   model_path = "./classifier_directory3"
#   model = AutoModelForSequenceClassification.from_pretrained(model_path, num_labels=5)

#   # Define test trainer
#   test_trainer = Trainer(model)
 
#   # Make prediction
#   raw_pred, _, _ = test_trainer.predict(test_dataset)

#   # Preprocess raw predictions
#   y_pred = np.argmax(raw_pred, axis=1)
#   if y_pred == 0:
#     return 'Friendship'
#   elif y_pred == 1:
#     return 'Honesty'
#   elif y_pred == 2:
#     return 'Patience'
#   elif y_pred == 3:
#     return 'Brave'
#   elif y_pred == 4:
#     return 'Respect'


#pred=prediction(['There was a girl called Rose who loved to sleep with her parents because she afraid to sleep alone. Her parents used to tuck her up in bed every night, but she always went to their bed in the middle of the night: “Can I sleep with you?” – she would ask.Her parent always let her sleep with them, but she was not a baby anymore, so, one day they told her:– “Rose, you are a big girl now, and you can´t sleep with us every night. Big girls have to sleep in their own beds, so we want to help you do that by singing you a song at bedtime.”Rose couldn´t wait until bedtime to hear the song. Her parents finally arrived to her room to sing their song: “Twinkle, twinkle, little star… how I wonder what you are…”Rose fell asleep, and didn´t wake up during the night.She had learnt to confront her fear and to be brave girl and  s '])
#print(pred) 
#pred=prediction(request.form.get("content"))  

# In[ ]:

# In[ ]:

from flask import Flask
app = Flask(__name__)

@app.route('/', methods =["GET","POST"])
def hello():
    db_store = firestore.client()
    users_ref = db_store.collection(u'books')
    docs = users_ref.stream()

    checklength = []
    for doc in docs:
        checklength.append(doc)

       

    dict1 = {}
    # dict1['author'] = request.form.get("author")
    dict1['content'] = request.form.get("content")
    dict1['title'] = request.form.get("title")    
    dict1['moral'] = request.form.get("moral")
    # dict1['moral'] = prediction(request.form.get("content")) 


    doc_ref = db_store.collection(u'books').document(u''+str(len(checklength)+1))
    doc_ref.set(dict1)
    
    return HTML_TEXT 




# In[ ]:
#please open collab file 
if __name__ == "__main__":
    app.run()


# In[ ]:





