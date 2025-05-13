from flask import Flask, send_from_directory, jsonify, request
from bs4 import BeautifulSoup
import requests
import os

app = Flask(__name__, static_folder='tamil-dictionary-website/public')

# Serve the home page (index.html)
@app.route('/')
def serve_home():
    return send_from_directory(app.static_folder, 'index.html')

# Serve other static files (like word.html, CSS, JS, etc.)
@app.route('/<path:path>')
def serve_static_files(path):
    return send_from_directory(app.static_folder, path)

# API endpoint to fetch word information
@app.route('/api/word', methods=['GET'])
def get_word_info():
    word = request.args.get('word')
    if not word:
        return jsonify({'error': 'No word specified'}), 400

    try:
        # Fetch the Wiktionary page
        url = f"https://en.wiktionary.org/wiki/{word}"
        response = requests.get(url)
        if response.status_code != 200:
            return jsonify({'error': f'No information found for "{word}"'}), 404

        # Parse the HTML content
        soup = BeautifulSoup(response.content, 'html.parser')

        # Extract Pronunciation
        pronunciation = []
        for ipa in soup.select('.IPA'):
            pronunciation.append(ipa.text)

        # Extract Etymology
        etymology = soup.find('span', {'id': 'Etymology'})
        etymology_text = etymology.find_next('p').text if etymology else 'No etymology found.'

        # Extract Definitions
        definitions = []
        for ol in soup.find_all('ol'):
            for li in ol.find_all('li', recursive=False):
                definitions.append(li.text)

        # Return the extracted data
        return jsonify({
            'word': word,
            'pronunciation': pronunciation,
            'etymology': etymology_text,
            'definitions': definitions
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000)