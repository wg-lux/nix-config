#   ${pythonEnv}/bin/python ${config.services.myCustomService.pythonFilePath} > ${config.services.myCustomService.path} 2>&1'

# Path: services/custom-service-flake/my-service.py

# Script imports torch and prints the result of torch.cuda.is_available() including timestamp to a log file
import torch
import datetime

print(f'{datetime.datetime.now()} - torch.cuda.is_available(): {torch.cuda.is_available()}')

