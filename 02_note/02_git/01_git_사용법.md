# Git 사용법
## Git 명령어
### remote
```bash
git remote add '[repository 별칭]' '[repository url 주소]'
git remote -v                           // repository 목록 확인
git remote remove '[repository 별칭]'   // 원격 repository 삭제
```
- GitHub에 생성한 repository를 Local에 있는 repository와 연결
- repository 별칭은 통상적으로 __origin__ 으로 표기
### add
```bash
git add .
```
- Local에 변경된 내용의 branch 생성
### commit
```bash
git commit -m '[commit comment]'
```
- 생성된 branch 저장
### push
```bash
git push '[repository 별칭]' '[branch 명]'
git push origin --all   // 모든 branch 전송
```
- 저장된 branch를 repository로 전송
### fatch
```bash
git fatch
```
- 원격 repository의 변경된 commit 내역들을 조회
### pull
```bash
git pull
```
- 변경된 commit 내역들을 Local repository의 내용들과 병합
