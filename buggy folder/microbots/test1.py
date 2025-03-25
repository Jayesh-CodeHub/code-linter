import paramiko
import requests
import threading
import subprocess
import os
import json
import time
import logging
from cryptography.fernet import Fernet

# Global Variables (Bad Practice: Hardcoded Credentials)
HOST = "192.168.1.100"
USER = "root"
PASSWORD = "password123"
API_URL = "http://example.com/api/data"

logging.basicConfig(level=logging.DEBUG) # Debug logging on

# Function to fetch data from an API (Poor Error Handling)
def fetch_api_data():
    response = requests.get(API_URL)  # No timeout set (Bad)
    if response.status_code == 200:
        data = json.loads(response.text)
        return data
    else:
        print("API call failed!")  # Bad practice (No proper logging)
        return None

# Function to execute SSH command (Multiple Issues)
def execute_ssh_command(command):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())  # Security Risk
    ssh.connect(HOST, username=USER, password=PASSWORD, timeout=5)  # Hardcoded credentials

    stdin, stdout, stderr = ssh.exec_command(command)  # No error handling
    output = stdout.read().decode()  # Potential Unicode issues
    ssh.close()
    return output

# Function to execute a shell command (Security Issue: Shell Injection)
def execute_shell_command(command):
    result = subprocess.run(command, shell=True, capture_output=True, text=True)  # shell=True (Security Risk)
    return result.stdout.strip()

# Function with overly complex logic (Radon Complexity Issue)
def process_data():
    data = fetch_api_data()
    if data:
        for item in data:
            for key in item.keys():
                print(f"Processing {key} -> {item[key]}")  # Redundant print
                time.sleep(0.5)  # Unnecessary delay
    else:
        print("No data received!")  # Bad logging practice

# Function with unnecessary threading (Poor Thread Management)
def threaded_function():
    threads = []
    for i in range(5):
        thread = threading.Thread(target=process_data)
        thread.start()
        threads.append(thread)

    for thread in threads:
        thread.join()  # No exception handling

# Function to encrypt a message (Unused Key, Redundant Code)
def encrypt_message(message):
    key = Fernet.generate_key()  # Generates a new key every time (Wrong!)
    cipher_suite = Fernet(key)
    encrypted_text = cipher_suite.encrypt(message.encode())
    return encrypted_text  # Key is lost, no way to decrypt!

# Main Execution Flow (Bad Practice: No __name__ Check)
command = "ls -l /var/log"
output = execute_ssh_command(command)
print("SSH Output:", output)

shell_output = execute_shell_command("echo Hello")
print("Shell Output:", shell_output)

threaded_function()  # Unnecessary threading

# Encrypt a test message
message = "SuperSecretData"
encrypted = encrypt_message(message)
print("Encrypted Message:", encrypted)
