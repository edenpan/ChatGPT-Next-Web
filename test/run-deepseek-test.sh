#!/bin/bash

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}DeepSeek-NVIDIA API 集成测试${NC}"
echo "=============================="

# 显示使用说明
echo -e "${BLUE}使用说明:${NC}"
echo "此脚本将测试DeepSeek API是否成功配置为使用NVIDIA的API端点。"
echo "它包含两个测试:"
echo "1. 标准请求测试 - 测试基本的API请求功能"
echo "2. 流式响应测试 - 测试流式(streaming)响应功能"
echo ""
echo -e "${YELLOW}在运行此脚本前，请确保:${NC}"
echo "1. 您已经修改了DeepSeek API实现以使用NVIDIA的API端点"
echo "2. Next.js开发服务器正在运行"
echo ""

# 确保脚本是可执行的
if [ ! -x "$0" ]; then
  echo -e "${YELLOW}提示: 此脚本需要执行权限。运行以下命令授予权限:${NC}"
  echo -e "${GREEN}chmod +x test/run-deepseek-test.sh${NC}"
  echo ""
fi

# 检查开发服务器是否正在运行
echo "检查Next.js开发服务器是否正在运行..."
if ! curl -s http://localhost:3000 > /dev/null; then
  echo -e "${RED}错误: Next.js开发服务器未运行!${NC}"
  echo "请先在另一个终端窗口运行以下命令:"
  echo -e "${GREEN}npm run dev${NC} 或 ${GREEN}yarn dev${NC}"
  echo "然后再次运行此测试脚本。"
  exit 1
fi

echo -e "${GREEN}开发服务器正在运行，开始执行测试...${NC}"

# 安装node-fetch（如果尚未安装）
if ! npm list node-fetch > /dev/null 2>&1; then
  echo "安装node-fetch依赖..."
  npm install --save-dev node-fetch@2
fi

# 运行标准测试
echo -e "\n${YELLOW}测试 1: 标准请求测试${NC}"
echo "执行DeepSeek-NVIDIA标准集成测试..."
npx ts-node test/deepseek-nvidia-test.ts

# 检查标准测试结果
STANDARD_TEST_RESULT=$?
if [ $STANDARD_TEST_RESULT -eq 0 ]; then
  echo -e "${GREEN}标准测试成功完成!${NC}"
else
  echo -e "${RED}标准测试失败!${NC}"
fi

# 询问是否运行流式测试
echo -e "\n${YELLOW}是否要运行流式响应测试? (y/n)${NC}"
read -r run_stream_test

if [[ $run_stream_test =~ ^[Yy]$ ]]; then
  # 运行流式测试
  echo -e "\n${YELLOW}测试 2: 流式响应测试${NC}"
  echo "执行DeepSeek-NVIDIA流式集成测试..."
  npx ts-node test/deepseek-nvidia-stream-test.ts
  
  # 检查流式测试结果
  STREAM_TEST_RESULT=$?
  if [ $STREAM_TEST_RESULT -eq 0 ]; then
    echo -e "${GREEN}流式测试成功完成!${NC}"
  else
    echo -e "${RED}流式测试失败!${NC}"
  fi
else
  echo "跳过流式响应测试。"
  STREAM_TEST_RESULT=0  # 如果用户选择不运行，则视为成功
fi

# 总结测试结果
echo -e "\n${YELLOW}测试结果总结:${NC}"
if [ $STANDARD_TEST_RESULT -eq 0 ] && [ $STREAM_TEST_RESULT -eq 0 ]; then
  echo -e "${GREEN}所有测试都成功完成!${NC}"
  echo "DeepSeek API已成功配置为使用NVIDIA的API端点。"
else
  echo -e "${RED}部分或全部测试失败!${NC}"
  echo "请检查错误信息并确保您的修改正确。"
fi

echo -e "\n${YELLOW}提示:${NC}"
echo "1. 确保您的网络可以访问NVIDIA的API服务"
echo "2. 如果测试失败，请检查控制台输出中的错误信息"
echo "3. 您也可以在浏览器中打开开发工具，查看网络请求的详细信息"
echo "4. 如果需要进一步调试，可以在app/api/deepseek.ts中添加更多的日志输出"