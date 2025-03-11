<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Three.js 강화된 페이지</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            overflow: hidden;
            font-family: 'Arial', sans-serif;
        }
        #container {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            z-index: 10;
        }
        .fancy-button {
            display: inline-block;
            padding: 15px 30px;
            margin: 10px;
            font-size: 18px;
            color: white;
            background: linear-gradient(45deg, #ff416c, #ff4b2b);
            border: none;
            border-radius: 50px;
            cursor: pointer;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
            text-decoration: none;
        }
        .fancy-button:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 25px rgba(0, 0, 0, 0.3);
            background: linear-gradient(45deg, #ff4b2b, #ff416c);
        }
        h1 {
            color: white;
            text-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
<div id="container">
    <h1>멋진 Three.js 페이지</h1>
    <button class="fancy-button" onclick="location.href='page01.jsp'">page01.jsp</button>
    <button class="fancy-button" onclick="location.href='page02.jsp'">page02.jsp</button>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
<script>
    // Three.js 설정
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer({ antialias: true });

    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.setClearColor(0x111133);
    document.body.appendChild(renderer.domElement);

    // 조명 추가
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
    scene.add(ambientLight);

    const pointLight = new THREE.PointLight(0xffffff, 1);
    pointLight.position.set(10, 10, 10);
    scene.add(pointLight);

    // 파티클 추가
    const particlesGeometry = new THREE.BufferGeometry();
    const particlesCount = 1500;

    const posArray = new Float32Array(particlesCount * 3);

    for(let i = 0; i < particlesCount * 3; i++) {
        posArray[i] = (Math.random() - 0.5) * 30;
    }

    particlesGeometry.setAttribute('position', new THREE.BufferAttribute(posArray, 3));

    const particlesMaterial = new THREE.PointsMaterial({
        size: 0.05,
        color: 0xffffff
    });

    const particlesMesh = new THREE.Points(particlesGeometry, particlesMaterial);
    scene.add(particlesMesh);

    // 애니메이션 구체 추가
    const sphereGeometry = new THREE.SphereGeometry(1, 32, 32);
    const sphereMaterial = new THREE.MeshPhongMaterial({
        color: 0x00ffff,
        emissive: 0x072534,
        side: THREE.DoubleSide,
        flatShading: true
    });

    const spheres = [];
    for (let i = 0; i < 10; i++) {
        const sphere = new THREE.Mesh(sphereGeometry, sphereMaterial);
        sphere.position.set(
            (Math.random() - 0.5) * 20,
            (Math.random() - 0.5) * 20,
            (Math.random() - 0.5) * 20
        );
        sphere.scale.set(
            Math.random() * 0.5,
            Math.random() * 0.5,
            Math.random() * 0.5
        );
        scene.add(sphere);
        spheres.push({
            mesh: sphere,
            speed: Math.random() * 0.01
        });
    }

    camera.position.z = 5;

    // 애니메이션 루프
    function animate() {
        requestAnimationFrame(animate);

        // 파티클 회전
        particlesMesh.rotation.x += 0.0005;
        particlesMesh.rotation.y += 0.0005;

        // 구체 움직임
        spheres.forEach(sphere => {
            sphere.mesh.rotation.x += sphere.speed;
            sphere.mesh.rotation.y += sphere.speed;
        });

        // 카메라 움직임
        camera.position.x = Math.sin(Date.now() * 0.0003) * 0.5;
        camera.position.y = Math.cos(Date.now() * 0.0002) * 0.5;
        camera.lookAt(scene.position);

        renderer.render(scene, camera);
    }

    // 창 크기 조정 이벤트
    window.addEventListener('resize', () => {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    });

    animate();
</script>
</body>
</html>