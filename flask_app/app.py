from flask import Flask
import os

app = Flask(__name__)

def read_counter():
    try:
        with open(os.path.join(os.path.dirname(__file__), "counter.txt"), "r") as file:
            counter = int(file.read())
    except FileNotFoundError:
        counter = 0
    return counter

def write_counter(counter):
    with open(os.path.join(os.path.dirname(__file__), "counter.txt"), "w") as file:
        file.write(str(counter))

@app.route('/')
def index():
    counter = read_counter()
    counter += 1
    write_counter(counter)
    return str(counter)

if __name__ == '__main__':
    app.run()
