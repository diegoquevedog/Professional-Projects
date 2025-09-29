""" Create environment: python -m venv venv
Activate environment: venv\Scripts\activate """
import kaggle
from kaggle.api.kaggle_api_extended import KaggleApi

api = KaggleApi()
api.authenticate()

handle = 'iamsouravbanerjee/airline-dataset'

#api.dataset_download_file(handle, file_name='Airline Dataset Updated - v2.csv')

api.dataset_download_files(handle, path='./', unzip = True)
