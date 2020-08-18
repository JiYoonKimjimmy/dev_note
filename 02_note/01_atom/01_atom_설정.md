# ATOM 설정
## GitHub 연동
1. GitHub repository 생성
1. 생성한 repository HTTPS url 주소 저장
1. ATOM > Packages > Githun > Toggle Git Tab 선택
    - 'create new repository'를 통해 새로운 project folder 생성
1. Termianl에서 해당 project folder Git 설정
    1. 해당 project folder로 이동
    1. git config --global user.name 'github user name'
    1. git config --global user.email 'github user email'
    1. git remote add origin 'repository HTTPS url'
##### git 설정 목록 확인
```bash
git config --list
```
---
## GitHub 사용법
### remote
```bash
git remote add '[repository 별칭]' '[repository url 주소]'
git remote -v   // repository 목록 확인
git remote remove '[repository 별칭]'   // 원격 repository 삭제
```
- GitHub에 생성한 repository를 Local에 있는 repository와 연결
- repository 별칭은 통상적으로 __origin__ 으로 표기
### add
```bash
git add
```
-
### commit
```bash
git commit -m '[commit comment]'
```
### push
```bash
git push '[repository 별칭]' '[branch 명]'
// 모든 branch의 commit 내용을 ㅓㄴ송
git push origin --all
```
- 원격 repository에 변경 내용을 전송
### pull & fatch

---
## Markdown editor 설정
### Plugin Package 설치 및 설정
- markdown-preview-enhanced : markdown 문서 미리보기 Plugin
- markdown-preview : ATOM 기본 markdown preview __비활성화__
- spell-check : 한글 오타 인식 문제로 __비활성화__

### Setting > Editor 설정
- 'Scroll Past End' & 'Soft Wrap' 체크
---
## Markdown 문법
##### 참조 : https://heropy.blog/2017/09/30/markdown/
