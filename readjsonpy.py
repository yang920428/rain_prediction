import json

json_file_path = "D:\\Program_set\\project_zike\\C-B0024-001.json"

# file = open(json_file_path , "r");

# for line in file:
#     print(line)

with open(json_file_path,"r",encoding="UTF-8") as json_file:
    data = json.load(json_file)

data_every_location = data['cwaopendata']['resources']['resource']['data']['surfaceObs']['location'] # list
num_station = len(data_every_location)

#print(data_every_location[0]['stationObsTimes']['stationObsTime'][0]) #station 0, time 0 data

pathsite = "D:\\Program_set\\project_zike\\site.txt"
fsite = open(pathsite, "w" ,encoding="UTF-8")
for i in range(num_station):
    stationdata = data_every_location[i]
    print(stationdata['station']['StationName'],file=fsite)
    path = "D:\\Program_set\\project_zike\\stationdata\\station_"+str(i)+".txt"
    pathlabel = "D:\\Program_set\\project_zike\\label\\label_"+str(i)+".txt"
    f = open(path , "w" ,encoding = "UTF-8")
    flabel = open(pathlabel , "w")
    num_time = len(stationdata['stationObsTimes']['stationObsTime'])
    data_every_time = stationdata['stationObsTimes']['stationObsTime'];
    for j in range(num_time):
        print(str(data_every_time[j]['DateTime'])+" "+str(data_every_time[j]['weatherElements']['AirPressure'])+" "+str(data_every_time[j]['weatherElements']['AirTemperature'])+" "+str(data_every_time[j]['weatherElements']['RelativeHumidity'])+" "+str(data_every_time[j]['weatherElements']['WindSpeed'])+" "+str(data_every_time[j]['weatherElements']['WindDirection'])+" "+str(data_every_time[j]['weatherElements']['Precipitation'])+" "+str(data_every_time[j]['weatherElements']['SunshineDuration']),file= f)
        if (str(data_every_time[j]['weatherElements']['SunshineDuration']) == "None"):
            continue
        if (str(data_every_time[j]['weatherElements']['Precipitation']) != "T" and str(data_every_time[j]['weatherElements']['Precipitation']) != "0.0" and str(data_every_time[j]['weatherElements']['Precipitation']) != "None"):
            print("1",file=flabel)
        else:
            print("-1",file=flabel);
    f.close()
    flabel.close()
fsite.close()