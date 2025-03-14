# DeepSeek-NVIDIA API 集成测试

本文档提供了关于DeepSeek API与NVIDIA API集成的测试说明和使用指南。

## 背景

我们修改了DeepSeek API的实现，使其使用NVIDIA的API端点和API密钥。这使得应用程序可以通过NVIDIA的服务来访问DeepSeek的模型，而无需更改前端代码或与API的交互方式。

主要修改包括：

1. 将请求重定向到NVIDIA的API端点 (`https://integrate.api.nvidia.com/v1`)
2. 使用NVIDIA提供的API密钥进行认证
3. 确保使用正确的模型名称 (`deepseek-ai/deepseek-r1`)

## 测试文件说明

本测试套件包含以下文件：

1. `deepseek-nvidia-test.ts` - 标准API请求测试
2. `deepseek-nvidia-stream-test.ts` - 流式响应API请求测试
3. `run-deepseek-test.sh` - 运行测试的Shell脚本
4. `DEEPSEEK-NVIDIA-README.md` - 本文档

## 运行测试

### 前提条件

在运行测试之前，请确保：

1. 您已经修改了DeepSeek API实现以使用NVIDIA的API端点
2. Next.js开发服务器正在运行
3. 您的网络可以访问NVIDIA的API服务

### 步骤

1. 确保Next.js开发服务器正在运行：

   ```bash
   npm run dev
   # 或
   yarn dev
   ```

2. 给测试脚本添加执行权限：

   ```bash
   chmod +x test/run-deepseek-test.sh
   ```

3. 运行测试脚本：

   ```bash
   ./test/run-deepseek-test.sh
   ```

4. 脚本将首先运行标准API请求测试，然后询问您是否要运行流式响应测试。

## 测试内容

### 标准API请求测试

标准测试会向DeepSeek API发送一个简单的聊天请求，并验证是否收到了有效的响应。这个测试验证了基本的API集成功能。

### 流式响应测试

流式响应测试会向DeepSeek API发送一个启用了流式响应的请求，并实时显示接收到的响应内容。这个测试验证了流式响应功能是否正常工作。

## 故障排除

如果测试失败，请检查以下几点：

1. 确保DeepSeek API实现已正确修改
2. 确保Next.js开发服务器正在运行
3. 检查网络连接，确保可以访问NVIDIA的API服务
4. 查看控制台输出中的错误信息
5. 检查API密钥是否正确
6. 确保请求体格式正确

## 修改说明

主要修改位于 `app/api/deepseek.ts` 文件中，包括：

1. 将基础URL从DeepSeek的API端点更改为NVIDIA的API端点
2. 使用硬编码的NVIDIA API密钥替换原来的授权头
3. 修改请求体，确保使用正确的模型名称

这些修改使得应用程序可以无缝地通过NVIDIA的API服务使用DeepSeek的模型。

## 注意事项

- API密钥是硬编码在代码中的，在生产环境中应考虑更安全的密钥管理方式
- 此集成仅支持DeepSeek的特定模型 (`deepseek-ai/deepseek-r1`)
- 如果NVIDIA更改了其API的结构或认证方式，可能需要更新实现