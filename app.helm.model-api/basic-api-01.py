from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/process_string', methods=['POST'])
def process_string():
    data = request.get_json()

    if 'input_string' not in data:
        return jsonify({"error": "JSON deve conter a chave 'input_string'"}), 400

    input_string = data['input_string']

    processed_string = input_string.upper()

    return jsonify({"processed_string": processed_string}), 200

if __name__ == '__main__':
    app.run(debug=True)
