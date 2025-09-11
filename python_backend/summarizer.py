from flask import Flask, request, jsonify
from transformers import T5ForConditionalGeneration, T5Tokenizer

app = Flask(__name__)
model_name = "t5-small"  # You can use "t5-base" or "t5-large" for better accuracy
tokenizer = T5Tokenizer.from_pretrained(model_name)
model = T5ForConditionalGeneration.from_pretrained(model_name)

@app.route('/summarize', methods=['POST'])
def summarize():
    data = request.get_json()
    text = data.get('text', '')
    if not text:
        return jsonify({'error': 'No text provided'}), 400

    inputs = tokenizer("summarize: " + text, return_tensors="pt", max_length=512, truncation=True)
    summary_ids = model.generate(inputs['input_ids'], max_length=150, min_length=50, length_penalty=2.0, num_beams=4, early_stopping=True)
    summary = tokenizer.decode(summary_ids[0], skip_special_tokens=True)

    return jsonify({'summary': summary})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
