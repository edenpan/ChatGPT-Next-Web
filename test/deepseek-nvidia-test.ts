import fetch from 'node-fetch';

/**
 * 测试DeepSeek API是否成功连接到NVIDIA的API服务
 */
async function testDeepSeekNvidiaIntegration() {
  console.log('开始测试DeepSeek到NVIDIA API的集成...');
  
  try {
    // 构建请求URL（使用本地开发服务器地址）
    const url = 'http://localhost:3000/api/deepseek/chat/completions';
    
    // 构建请求体
    const requestBody = {
      model: 'deepseek-chat', // 这个会被后端替换为 "deepseek-ai/deepseek-r1"
      messages: [
        {
          role: 'user',
          content: '你好，请简单介绍一下你自己'
        }
      ],
      temperature: 0.7,
      max_tokens: 500,
      stream: false
    };
    
    console.log('发送请求到:', url);
    console.log('请求体:', JSON.stringify(requestBody, null, 2));
    
    // 发送请求
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        // 不需要提供Authorization头，因为我们在后端硬编码了NVIDIA的API密钥
      },
      body: JSON.stringify(requestBody)
    });
    
    // 检查响应状态
    if (response.ok) {
      const data = await response.json();
      console.log('测试成功! 收到响应:');
      console.log(JSON.stringify(data, null, 2));
      return true;
    } else {
      const errorText = await response.text();
      console.error('测试失败! 状态码:', response.status);
      console.error('错误信息:', errorText);
      return false;
    }
  } catch (error) {
    console.error('测试过程中发生错误:', error);
    return false;
  }
}

// 如果直接运行此文件，则执行测试
if (require.main === module) {
  testDeepSeekNvidiaIntegration()
    .then(success => {
      console.log('测试完成，结果:', success ? '成功' : '失败');
      process.exit(success ? 0 : 1);
    })
    .catch(err => {
      console.error('测试执行出错:', err);
      process.exit(1);
    });
}

export { testDeepSeekNvidiaIntegration };