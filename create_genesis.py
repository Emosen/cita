#!/usr/bin/env python  
# coding=utf-8  
  
import json  
import os  
import copy  
import sys
import time
import commands
import re
import rlp
from rlp.utils import decode_hex, encode_hex 
from utils import privtopub
  
def make_json():
    path = sys.argv[3]
    if len(sys.argv)==5:
        pubkey = sys.argv[4]
        if pubkey[0:2] != "0x" and pubkey[0:2] != "0X":
            pubkey = "0x"+pubkey
    else:
        secret_path = os.path.join(path, "privkey")
        secret_key = open(secret_path, "r")
        sec_key = secret_key.read()
        pubkey = "0x"+encode_hex(privtopub(decode_hex(sec_key)))[2:]
    crypto = sys.argv[2]
    identifier = sys.argv[1]
    data = dict()
    admin = dict(pubkey=pubkey,crypto=crypto,identifier=identifier)
    addresses = ["0x8e1d62d3872a07a04449e8549c031da23e818c2caa3b0e72bc5a5ed39443680a","0x8e1d62d3872a07a04449e8549c031da23e818c2caa3b0e72bc5a5ed39443680b","0x8e1d62d3872a07a04449e8549c031da23e818c2caa3b0e72bc5a5ed39443680c","0x8e1d62d3872a07a04449e8549c031da23e818c2caa3b0e72bc5a5ed39443680d"]
    code0 = get_code("contracts/AccountManager.sol")

    code1 = get_code("contracts/AccountManager.sol")
    code2 = get_code("contracts/PermissionManager.sol")
    code3 = get_code("contracts/QuotaManager.sol")
    data["contracts"] = {addresses[0]:code0, addresses[1]:code1, addresses[2]:code2, addresses[3]:code3}
    timestamp = int(time.time())
    data["prevhash"] = "0x0000000000000000000000000000000000000000000000000000000000000000"
    data["admin"] = admin
    data["timestamp"] = timestamp
    dump_path = os.path.join(path, "genesis.json")
    f = open(dump_path, "w")
    json.dump(data, f, indent=4)
    f.close()

def get_code(contract_file_path):
    token = commands.getoutput('solc ' + contract_file_path + ' --bin')+"z"
    code = re.findall(r"\nBinary: \n(.+?)z",token)
    return code[0]

make_json()
