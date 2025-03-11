<%@ page import="java.net.http.HttpClient" %>
<%@ page import="java.net.http.HttpRequest" %>
<%@ page import="com.sun.net.httpserver.HttpPrincipal" %>
<%@ page import="java.net.URI" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@ page import="io.github.cdimascio.dotenv.Dotenv" %>
<%@ page import="java.net.http.HttpResponse" %>
<%@ page import="com.fasterxml.jackson.core.type.TypeReference" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="io.github.s0ooo0k.day361.model.GeminiResponse" %>
<% request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
    <title>요청 객체 다루기</title>
    <!-- Three.js 라이브러리 추가 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <style>
        @font-face {
            font-family: 'GongGothicMedium';
            src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff') format('woff');
            font-weight: normal;
            font-style: normal;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'GongGothicMedium', normal;
        }

        body {
            background-color: #f5f7fa;
            padding: 40px;
            max-width: 1000px;
            margin: 0 auto;
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative; /* Three.js 캔버스 배치를 위해 추가 */
        }

        /* Three.js 캔버스 스타일 */
        canvas {
            position: fixed;
            top: 0;
            left: 0;
            z-index: -1; /* 폼 뒤에 배치 */
            width: 100%;
            height: 100%;
        }

        .container {
            width: 100%;
            position: relative; /* Three.js 캔버스 위에 배치 */
            z-index: 1;
        }

        form {
            margin-bottom: 30px;
            display: flex;
            gap: 10px;
            width: 100%;
            position: relative;
            z-index: 2; /* 캔버스 위에 표시 */
        }

        input[name="prompt"] {
            flex: 1;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            outline: none;
            transition: all 0.3s ease;
            background-color: rgba(255, 255, 255, 0.8); /* 약간 투명하게 설정 */
        }

        input[name="prompt"]:focus {
            border-color: #4285f4;
            box-shadow: 0 0 0 2px rgba(66, 133, 244, 0.2);
            transform: translateY(-2px);
            background-color: rgba(255, 255, 255, 0.95); /* 포커스시 더 불투명하게 */
        }

        input[name="prompt"]::placeholder {
            color: #aaa;
        }

        button {
            background-color: #4285f4;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 24px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        button:hover {
            background-color: #3367d6;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        button:active {
            transform: translateY(0);
        }

        /* 버튼 리플 이펙트 */
        button::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 5px;
            height: 5px;
            background: rgba(255, 255, 255, 0.5);
            opacity: 0;
            border-radius: 100%;
            transform: scale(1, 1) translate(-50%, -50%);
            transform-origin: 50% 50%;
        }

        button:focus:not(:active)::after {
            animation: ripple 1s ease-out;
        }

        @keyframes ripple {
            0% {
                transform: scale(0, 0);
                opacity: 0.5;
            }
            100% {
                transform: scale(100, 100);
                opacity: 0;
            }
        }

        section {
            background-color: rgba(255, 255, 255, 0.85); /* 약간 투명하게 설정 */
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            width: 100%;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            z-index: 2; /* 캔버스 위에 표시 */
        }

        section:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
            background-color: rgba(255, 255, 255, 0.95); /* 호버시 더 불투명하게 */
        }

        section:nth-child(3) {
            border-left: 4px solid #4285f4;
            background-color: rgba(230, 242, 255, 0.85);
        }

        section:nth-child(4) {
            border-left: 4px solid #34a853;
            white-space: pre-wrap;
            max-height: 500px;
            overflow-y: auto;
            background-color: rgba(240, 248, 255, 0.85);
        }

        /* 응답 섹션의 스크롤바 스타일링 */
        section:nth-child(4)::-webkit-scrollbar {
            width: 8px;
        }

        section:nth-child(4)::-webkit-scrollbar-track {
            background: #e6f2ff;
            border-radius: 4px;
        }

        section:nth-child(4)::-webkit-scrollbar-thumb {
            background: #a6c8ff;
            border-radius: 4px;
        }

        section:nth-child(4)::-webkit-scrollbar-thumb:hover {
            background: #7baaf7;
        }

        /* 헤더 텍스트 (프롬프트:, 답변:) 스타일링 */
        section::before {
            font-weight: 700;
            margin-right: 10px;
        }

        /* 로딩 애니메이션 (옵션) */
        .loading-dots {
            display: inline-block;
        }

        .loading-dots::after {
            content: '...';
            animation: dots 1.5s steps(4, end) infinite;
            display: inline-block;
            width: 1.5em;
            text-align: left;
        }

        @keyframes dots {
            0%, 20% { content: '.'; }
            40% { content: '..'; }
            60% { content: '...'; }
            80%, 100% { content: ''; }
        }

        /* 페이지 로드 애니메이션 */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .container {
            animation: fadeIn 0.6s ease-out forwards;
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            body {
                padding: 20px;
            }

            form {
                flex-direction: column;
            }

            button {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<%
    String answer = (String) request.getAttribute("answer");
    String prompt = (String) request.getAttribute("prompt"); %>

<div class="container">
    <form>
        <input name="prompt" placeholder="프롬프트를 입력해주세요">
        <button>제출</button>
    </form>
    <section>
        프롬프트 : <%= request.getParameter("prompt") %>
    </section>
    <section>
        답변 : <%= answer %>
    </section>
</div>

<!-- Three.js 애니메이션 초기화 스크립트 -->
<script>
    // Three.js 설정
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer({ alpha: true }); // 투명 배경
    renderer.setSize(window.innerWidth, window.innerHeight);
    document.body.appendChild(renderer.domElement);

    // 파티클 시스템 생성
    const particlesGeometry = new THREE.BufferGeometry();
    const particleCount = 1000;

    const positions = new Float32Array(particleCount * 3);
    const colors = new Float32Array(particleCount * 3);

    for (let i = 0; i < particleCount * 3; i += 3) {
        // 랜덤 위치 생성
        positions[i] = (Math.random() - 0.5) * 2000;
        positions[i + 1] = (Math.random() - 0.5) * 2000;
        positions[i + 2] = (Math.random() - 0.5) * 2000;

        // 그라데이션 색상 (파란색 계열)
        colors[i] = Math.random() * 0.2;
        colors[i + 1] = Math.random() * 0.5;
        colors[i + 2] = Math.random() * 0.5 + 0.5;
    }

    particlesGeometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    particlesGeometry.setAttribute('color', new THREE.BufferAttribute(colors, 3));

    const particlesMaterial = new THREE.PointsMaterial({
        size: 3,
        vertexColors: true,
        transparent: true,
        opacity: 0.8
    });

    const particleSystem = new THREE.Points(particlesGeometry, particlesMaterial);
    scene.add(particleSystem);

    // 카메라 위치 설정
    camera.position.z = 1000;

    // 마우스 움직임에 따른 인터랙션 변수
    let mouseX = 0;
    let mouseY = 0;
    let windowHalfX = window.innerWidth / 2;
    let windowHalfY = window.innerHeight / 2;

    // 마우스 이벤트 리스너
    document.addEventListener('mousemove', (event) => {
        mouseX = (event.clientX - windowHalfX) * 0.05;
        mouseY = (event.clientY - windowHalfY) * 0.05;
    });

    // 창 크기 변경 이벤트 처리
    window.addEventListener('resize', () => {
        windowHalfX = window.innerWidth / 2;
        windowHalfY = window.innerHeight / 2;
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    });

    // 폼 입력 필드 이벤트 처리
    const inputField = document.querySelector('input[name="prompt"]');

    inputField.addEventListener('focus', () => {
        // 입력 필드 포커스시 파티클 색상 변경
        particlesMaterial.size = 4;

        // 파티클 색상 변경 (더 밝은 색상으로)
        const colors = particlesGeometry.attributes.color.array;
        for (let i = 0; i < particleCount * 3; i += 3) {
            colors[i] = Math.random() * 0.2 + 0.2; // 빨간색 성분 증가
            colors[i + 1] = Math.random() * 0.5 + 0.3; // 녹색 성분 증가
            colors[i + 2] = Math.random() * 0.3 + 0.7; // 파란색 성분 증가
        }
        particlesGeometry.attributes.color.needsUpdate = true;
    });

    inputField.addEventListener('blur', () => {
        // 입력 필드에서 포커스 해제시 원래 색상으로
        particlesMaterial.size = 3;

        // 파티클 색상 초기화
        const colors = particlesGeometry.attributes.color.array;
        for (let i = 0; i < particleCount * 3; i += 3) {
            colors[i] = Math.random() * 0.2;
            colors[i + 1] = Math.random() * 0.5;
            colors[i + 2] = Math.random() * 0.5 + 0.5;
        }
        particlesGeometry.attributes.color.needsUpdate = true;
    });

    // 애니메이션 루프
    function animate() {
        requestAnimationFrame(animate);

        // 파티클 회전
        particleSystem.rotation.x += 0.0003;
        particleSystem.rotation.y += 0.0005;

        // 마우스 움직임에 따라 카메라 약간 회전
        camera.position.x += (mouseX - camera.position.x) * 0.01;
        camera.position.y += (-mouseY - camera.position.y) * 0.01;
        camera.lookAt(scene.position);

        renderer.render(scene, camera);
    }

    // 애니메이션 시작
    animate();
</script>
</body>
</html>