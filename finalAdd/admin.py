#!/usr/bin/env python
# coding: utf-8

# In[1]:


from transformers import AutoModelForSequenceClassification, AutoTokenizer, BertTokenizer, BertForSequenceClassification
import pandas as pd
import numpy as np
from transformers import EarlyStoppingCallback
from transformers import TrainingArguments, Trainer
import torch
from flask import Flask, session, render_template, request, redirect
import firebase_admin
from firebase_admin import db
from firebase_admin import credentials
from flask import Flask, request, url_for ,flash , jsonify 
from firebase_admin import firestore
import pyrebase
from datetime import timedelta
from flask import session, app
import time
databaseURL = 'https://read-me-a-story3-default-rtdb.firebaseio.com/'

cred_object = credentials.Certificate("./config/firebase.json")
default_app = firebase_admin.initialize_app(cred_object, {
    'databaseURL': databaseURL,
})


app = Flask(__name__)

db = firestore.client()
todo_ref = db.collection(u'books')
todo_ref2= db.collection(u'reader')

config = {
    'apiKey': "AIzaSyA9f97gGu55wjvB7Nsr75VJHFm71w1b7p0",
    'authDomain': "authenticatepy1.firebaseapp.com",
    'projectId': "authenticatepy1",
    'storageBucket': "authenticatepy1.appspot.com",
    'messagingSenderId': "70785395579",
    'appId': "1:70785395579:web:2ced190f1e121376b0ebde",
    'measurementId': "G-RS703MBCMF",
    'databaseURL': ''
}

firebase = pyrebase.initialize_app(config)
auth = firebase.auth()

app.secret_key = 'secret'


# In[2]:




# In[3]:


# In[4]:
# Create torch dataset


class Dataset(torch.utils.data.Dataset):
    def __init__(self, encodings, labels=None):
        self.encodings = encodings
        self.labels = labels

    def __getitem__(self, idx):
        item = {key: torch.tensor(val[idx])
                for key, val in self.encodings.items()}
        if self.labels:
            item["labels"] = torch.tensor(self.labels[idx])
        return item

    def __len__(self):
        return len(self.encodings["input_ids"])

# In[5]:

# def prediction(x):
#   x_test = ['']
#   tokenizer = AutoTokenizer.from_pretrained("roberta-base")
#   X_test_tokenized = tokenizer(x_test, padding=True, truncation=True, max_length=512)

#   # Create torch da

#   test_dataset = Dataset(X_test_tokenized)

#   # Load trained model
#   model_path = "./classifier_directory"
#   model = AutoModelForSequenceClassification.from_pretrained(model_path, num_labels=5)

#   # Define test trainer
#   test_trainer = Trainer(model)

#   # Make prediction
#   raw_pred, _, _ = test_trainer.predict(test_dataset)
#   tokenizer = AutoTokenizer.from_pretrained("roberta-base")


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

# pred=prediction(['afraid,fear,courage,brave,determined '])
# print(pred)


# In[ ]:

# In[ ]:

# log in

@app.route('/', methods=['POST', 'GET'])
def index():

    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        try:
            user = auth.sign_in_with_email_and_password(email, password)
            session['user'] = email
            return redirect(url_for('options'))
            
        except:
            flash('Email or Password is incorrect')
    return render_template('home.html')
# log out
@app.before_request
def make_session_permanent():
    session.permanent = True
    app.permanent_session_lifetime = timedelta(minutes=5)

@app.route('/logout')
def logout():
    session.pop('user')
    return redirect('/')


@app.route('/options')
def options():
     todo_id = request.args.get('id')  
     if todo_id:
         todo = todo_ref.document(todo_id).get(field_paths={'moral'})
         return jsonify(todo.to_dict()), 200
     else:
          docs = todo_ref.stream()
          countP=0
          countB=0
          countH=0
          countF=0
          countR=0
          for doc in docs:
            moral = u'{}'.format(doc.to_dict()['moral'])
            if moral=="Patience":
             value = countP + 1
             countP=value
             
            if moral=="Brave":
             value = countB + 1
             countB=value

            if moral=="Honesty":
              value = countH + 1
              countH=value 

            if moral=="Friendship":
              value = countF + 1
              countF=value  
              
            if moral=="Respect":
              value = countR + 1
              countR=value  
     total=countP+countB+countF+countH+countR
     
     m1="The total is: {}".format(total)   
     m1=f"The total is: {total} "
     m1="The total is %d " % (total)
     m1="The Total Number Of Stories: " + str(total)

    #  m2="Respect: {}".format(countR)   
    #  m2=f"Respect: {countR} "
    #  m2="Respect %d " % (countR)
    #  m2="Respect: " + str(countR)
     
    #  m3="Brave: {}".format(countB)   
    #  m3=f"Brave: {countB} "
    #  m3="Brave %d " % (countB)
    #  m3="Brave: " + str(countB)

     
    #  m4="Honesty: {}".format(countH)   
    #  m4=f"Honesty: {countH} "
    #  m4="Honesty %d " % (countH)
    #  m4="Honesty: " + str(countH)

     
    #  m5="Patience: {}".format(countP)   
    #  m5=f"Patience: {countP} "
    #  m5="Patience %d " % (countP)
    #  m5="Patience: " + str(countP)

     
    #  m6="Friendship: {}".format(countF)   
    #  m6=f"Friendship: {countF} "
    #  m6="Friendship %d " % (countF)
    #  m6="Friendship: " + str(countF)

     flash(m1 , 'category1')
     flash(countR, 'category2')
     flash(countF, 'category3')
     flash(countH, 'category4')
     flash(countP, 'category5')
     flash(countB, 'category6')

     todo_id = request.args.get('id')  
     if todo_id:
         todo = todo_ref2.document(todo_id).get(field_paths={'ID'})
         return jsonify(todo.to_dict()), 200
     else:
          docs = todo_ref2.stream()
          countUser=0
          for doc in docs:
            user = u'{}'.format(doc.to_dict()['ID'])
            if "ID":
             value = countUser + 1
             countUser=value
     U="N: {}".format(countUser)   
     U=f"N: {countUser} "
     U="N %d " % (countUser)
     U="Number Of Users: " + str(countUser)

     flash(U , 'category7')  

     return render_template('options.html')

# edit 

@app.route('/Edit', methods =["GET","POST"])
def edit():
        
        todo_id = request.args.get('id')  
        if todo_id:
         todo = todo_ref.document(todo_id).get(field_paths={'title'})
         return jsonify(todo.to_dict()), 200
        else:
       
          docs = todo_ref.stream()
          for doc in docs:
            title = u'{}'.format(doc.to_dict()['title'])
            flash(title, 'category2')
        
        return render_template('edit.html')

        #edit-form
@app.route('/editform', methods=["GET", "POST"])
def editform():
    return render_template('edit-form.html')


    #delete
@app.route('/Delete', methods =["GET","POST"])
def delete():
        #db_store = firestore.client()
        #users_ref = db_store.collection(u'books')
        #docs = users_ref.stream()
    #checklength1 = '<ul>'
    #for doc in docs:
     #   checklength1 += '<li>' + doc.title + '</li>'
    #checklength1 += '</ul>'
    #register = db.child("books").child("title").get()
    #registerList = register.val()
        todo_id = request.args.get('id')  
        if todo_id:
         todo = todo_ref.document(todo_id).get(field_paths={'title'})
         return jsonify(todo.to_dict()), 200
        else:
       # all_todos = [doc.get({u'title'}).to_dict() for doc in todo_ref]
       # for doc in all_todos:
        #    print(all_todos.get({u'title'}))
       # return jsonify(all_todos), 200
          docs = todo_ref.stream()
          for doc in docs:
            title = u'{}'.format(doc.to_dict()['title'])
            flash(title, 'category2')
        #return jsonify(title)
        return render_template('delete.html')

@app.route("/forward/", methods=['POST'])
def move_forward():
    #Moving forward code
    #forward_message = "Moving Forward..."
    #return render_template('index.html', forward_message=forward_message)
    title2 = request.form['delete']
    docs = db.collection(u'books').where("title", "==", title2).get()
    for doc in docs:
        key = doc.id
        db.collection(u'books').document(key).delete()
    flash('book has been removed successfully', 'category3')
    return render_template('delete.html')
# add


@app.route('/Add', methods=["GET", "POST"])
def hello():
    return render_template('classifier.html')


@app.route('/Save_data', methods=['GET', 'POST'])
def save_Data():
    print(request.form)

    curr_time = str(time.time_ns())

    dict1 = {}
    dict1['titleSmall'] = request.form.get("titleSmall")
    dict1['title'] = request.form.get("title")
    dict1['content'] = request.form.get("content")
    dict1['picture'] = request.form.get("picture")
    dict1['moral'] = request.form.get("moral")  # this shows overload error
    dict1['createdOn'] = firestore.SERVER_TIMESTAMP

    db.collection(u'books').document(curr_time).set(dict1)
    return "save successfully"

@app.route('/Cancel_data', methods=['GET', 'POST'])
def cancel_Data():
    print(request.form)

    curr_time = str(time.time_ns())

    dict1 = {}
    dict1['titleSmall'] = request.form.get("titleSmall")
    dict1['title'] = request.form.get("title")
    dict1['content'] = request.form.get("content")
    dict1['picture'] = request.form.get("picture")
    dict1['moral'] = request.form.get("moral")  # this shows overload error
    dict1['createdOn'] = firestore.SERVER_TIMESTAMP

    db.collection(u'canceledStories').document(curr_time).set(dict1)
    return "canceled sucessfully"



@app.route('/Add_pred', methods=['GET', 'POST'])
def prediction():

    print('text from front end')
    print(request.form.get('content'))
   # prediction
    tokenizer = AutoTokenizer.from_pretrained("roberta-base")
    X_test = [request.form.get('content')]
    #X_test=['honesty truth lie honest']
    print(X_test)
    X_test_tokenized = tokenizer(
        X_test, padding=True, truncation=True, max_length=512)
    print(X_test_tokenized)
# Create torch dataset
    test_dataset = Dataset(X_test_tokenized)

 # Load trained model
    model_path = "./classifier_directory"
    model = AutoModelForSequenceClassification.from_pretrained(
        model_path, num_labels=5)

    # Define test trainer
    test_trainer = Trainer(model)

    # Make prediction

    raw_pred, _, _ = test_trainer.predict(test_dataset)

    # Preprocess raw predictions
    y_pred = np.argmax(raw_pred, axis=1)
    pred = ''
    if y_pred == 0:
        pred = 'Friendship'
    elif y_pred == 1:
        pred = 'Honesty'
    elif y_pred == 2:
        pred = 'Patience'
    elif y_pred == 3:
        pred = 'Brave'
    elif y_pred == 4:
        pred = 'Respect'

    return pred


# In[ ]:
if __name__ == "__main__":
    # app.debug = True
    app.run(debug=True, port=5001)


# In[ ]: