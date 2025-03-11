<%@ page import="java.util.Arrays" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>세션과 쿠키</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>

    <style>
        @font-face {
            font-family: 'GongGothicMedium';
            src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff') format('woff');
            font-weight: normal;
            font-style: normal;
        }

        * {
            font-family: 'GongGothicMedium', normal;
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 0;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            text-align: center;
        }

        #canvas-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1; /* 배경으로 설정 */
        }

        /* 전체 컨텐츠 중앙 정렬 */
        .content {
            position: relative;
            z-index: 1;
            background: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 15px;
            width: 350px;
            box-shadow: 0px 0px 15px rgba(0, 0, 255, 0.3);
        }

        input, button {
            margin-top: 10px;
            padding: 10px;
            width: 100%;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }

        button {
            background: blue;
            color: white;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background: darkblue;
        }
    </style>
</head>
<body>

<div id="canvas-container"></div>

<form method="post" class="content">
    <p>세션 좋아! 쿠키 좋아!</p>
    <p>세션이 전하는 행운의 숫자 : <%= session.getAttribute("lucky_number")%></p>
    <p>쿠키가 전하는 행운의 숫자 : <%= Arrays.stream(request.getCookies()).filter(cookie -> cookie.getName().equals("cookie_number")).findFirst().orElse(new Cookie("cookie_number", "-1")).getValue() %></p>
    <label>
        아이디
        <input name="id">
    </label>
    <label>
        비밀번호
        <input name="pw" type="password">
    </label>
    <button>로그인</button>
</form>

<script>
    // Three.js 기본 설정
    let scene = new THREE.Scene();
    let camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    let renderer = new THREE.WebGLRenderer({ alpha: true });

    renderer.setSize(window.innerWidth, window.innerHeight);
    document.getElementById('canvas-container').appendChild(renderer.domElement);

    // 조명 추가
    let light = new THREE.PointLight(0xffffff, 1.5);
    light.position.set(10, 10, 10);
    scene.add(light);

    // 파란색 구체 생성
    let spheres = [];
    let sphereGeometry = new THREE.SphereGeometry(1, 32, 32);
    let sphereMaterial = new THREE.MeshPhongMaterial({ color: 0x4287f5, emissive: 0x0044ff });

    for (let i = 0; i < 10; i++) {
        let sphere = new THREE.Mesh(sphereGeometry, sphereMaterial);
        sphere.position.set(
            (Math.random() - 0.5) * 10,
            (Math.random() - 0.5) * 10,
            (Math.random() - 0.5) * 10
        );
        sphere.userData.velocity = {
            x: (Math.random() - 0.5) * 0.005,  // 속도 감소
            y: (Math.random() - 0.5) * 0.005,
            z: (Math.random() - 0.5) * 0.005
        };
        spheres.push(sphere);
        scene.add(sphere);
    }

    camera.position.z = 5;

    // 애니메이션 함수
    function animate() {
        requestAnimationFrame(animate);

        // 구체들을 천천히 움직이도록 설정
        spheres.forEach(sphere => {
            sphere.position.x += sphere.userData.velocity.x;
            sphere.position.y += sphere.userData.velocity.y;
            sphere.position.z += sphere.userData.velocity.z;

            // 경계값에서 반대 방향으로 튕기도록 설정
            if (sphere.position.x > 5 || sphere.position.x < -5) {
                sphere.userData.velocity.x *= -1;
            }
            if (sphere.position.y > 5 || sphere.position.y < -5) {
                sphere.userData.velocity.y *= -1;
            }
            if (sphere.position.z > 5 || sphere.position.z < -5) {
                sphere.userData.velocity.z *= -1;
            }
        });

        renderer.render(scene, camera);
    }

    animate();

    // 화면 크기 조절 대응
    window.addEventListener('resize', () => {
        let width = window.innerWidth;
        let height = window.innerHeight;
        renderer.setSize(width, height);
        camera.aspect = width / height;
        camera.updateProjectionMatrix();
    });
</script>

</body>
</html>