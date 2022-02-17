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
## Markdown editor 설정
### Plugin Package 설치 및 설정
- markdown-preview-enhanced : markdown 문서 미리보기 Plugin
- markdown-preview : ATOM 기본 markdown preview __비활성화__
- spell-check : 한글 오타 인식 문제로 __비활성화__
### Setting > Editor 설정
- 'Scroll Past End' & 'Soft Wrap' 체크
### Markdown 문법
##### 참조 : https://heropy.blog/2017/09/30/markdown/

---

## `snippets` 적용
```json
'.text.md':
  'Jekyll Code Block':
    'prefix': 'codeblock'
    'body': '{% highlight $1 %}$2\n{% endhighlight %}'
  'Start Jekyll Code Block':
    'prefix': 'startcodeblock'
    'body': '{% highlight $1 %}'
  'End Jekyll Code Block':
    'prefix': 'endcodeblock'
    'body': '{% endhighlight %}'
  'br Tag Element':
    'prefix': 'br'
    'body': '<br>\n'
```
