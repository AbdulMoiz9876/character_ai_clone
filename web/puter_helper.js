window.puter_ai_chat = async (prompt, options = {}) => {
  try {
    const response = await puter.ai.chat(prompt, {
      model: options.model || 'gpt-3.5-turbo',
      stream: false
    });
    return response.text || '';
  } catch (error) {
    console.error('Puter AI error:', error);
    return '';
  }
};