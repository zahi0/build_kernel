**使用github action在线编译安卓内核，使用proton-clang作为编译器**
### 食用方法
1. 点个Start
2. fork这个项目
3. 修改 .github/workflows/build_kernel.yml 和 build_tool.sh （要修改的内容已在文件里注释）
4. 项目主页 Actions --> build_kernel --> Run workflow，编译成功后找到Artifacts，下载解压就是内核了
