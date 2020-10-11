import pickle
import os
from sklearn.ensemble import RandomForestClassifier
from sklite import LazyExport

os.chdir('C:/Users/user/Desktop/test_app/test/')

clf = pickle.load(open('sample_model.sav', 'rb'))
lazy = LazyExport(clf)
lazy.save('sample_model.json')