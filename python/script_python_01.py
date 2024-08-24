import os #importar comandos (sistema operativo)

# Carpeta dataset #
location = "C:/Users/ASUS/CERTUS/proyecto_parcial/python/dataset" #root

# Validad si existe la carpeta #
if not os.path.exists(location): #si no existe
    #creo carpeta
    os.mkdir(location)
else: #si existe carpeta
    #borramos contenido
    for root, dirs, files in os.walk (location, topdown=False):
        for name in files: 
            os.remove(os.path.join(root,name)) #eliminar archivos
        for name in dirs:
            os.rmidir(os.path.join(root,name)) #eliminar carpetas (solo se pueden eliminar carpetas vacias)


#Descargar dataset #
from kaggle.api.kaggle_api_extended import KaggleApi 

#Autenticarnos
api = KaggleApi()
api.authenticate()

#print(api.dataset_list(search=''))

api.dataset_download_files('youssefismail20/olympic-games-1994-2024', path=location, force=True, quiet=False, unzip=True)















