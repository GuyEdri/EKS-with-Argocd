from flask import Blueprint, render_template, request, send_from_directory, abort
import requests
import os
import json
from datetime import datetime
from forecast import Forecast


views = Blueprint(__name__, "views")                                                   
key = '5bb5a99a036951f1cd3dd0529052f0e9'                                                         
                                                                                                
@views.route("/")
def home():
    bg_color = os.environ.get('BG_COLOR', '#F8F9FA')  
    return render_template("index.html", bg_color=bg_color)                    


@views.route("/", methods=['GET', 'POST'])                                                   
def get_api():                                                                      
    location = request.form['location']
    response = requests.get(f"https://api.openweathermap.org/data/2.5/forecast?q={location}&appid={key}")
    data = response.json()                                                                       
    if response.status_code == 200:
        fore_list = []                                                                           
        fore_list.append(data['city']['name'])                                                   
        fore_list.append(data['city']['country'])                                                 
        for element in data['list']:                                                              
            if element['dt_txt'][11:] == '09:00:00' or element['dt_txt'][11:] == '21:00:00':     
                date = element['dt_txt'][:10]
                time = element['dt_txt'][11:19]
                temp = element["main"]["temp"] 
                humidity = element["main"]["humidity"]                                          
                obj = Forecast(date, time, temp, humidity)                                   
                fore_list.append(obj)
        
         # Check if history directory exists, if not create it
        if not os.path.exists('history'):
            os.makedirs('history')

        # Save the data to a JSON file
        filename = f"{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}_{location}.json"
        with open(f"history/{filename}", "w") as jsonfile:
            json.dump(data, jsonfile)

        return render_template("index.html", data_list=fore_list)                               
    else:
        return "Error: bad input (probally there is no such country or city)"


@views.route("/history")
def history():
    files = os.listdir('history')
    return render_template("history.html", files=files)
    
@views.route("/history/<filename>")
def download_file(filename):
    history_dir = os.path.abspath('history')

    if os.path.exists(os.path.join(history_dir, filename)):
        return send_from_directory(directory=history_dir, path=filename, as_attachment=True)
    else:
        abort(404)