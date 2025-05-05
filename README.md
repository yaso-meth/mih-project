<h1>How to create your flavour of the MIH Server</h1>
<h2>Prerequisite:-</h2>
<ol>
  <li>Ubuntu Server OS installed (24.04 tested)</li>
  <li>Docker is Installed.</li>
  <li>Git is Installed.</li>
  <li>Sudo permission granted.</li>
</ol>
<h2>Get Started:-</h2>
<ol>
  <li>Clone Git Repo.</li>
  <li>Navigate to Mzansi-Innovation-Hub directory. <pre><code>cd Mzansi-Innovation-Hub</code></pre></li>
  <li>Start MIH Server</li>
  <ol>
    <li>Non-Prod: <pre><code>sudo docker compose up -d --build</code></pre></li>
    <li>Prod: <pre><code>sudo docker compose --profile prod up -d --build</code></pre></li>
    <li>Prod with Letsincrypt certificate Generation: <pre><code>sudo docker compose --profile prod --profile withCert up -d --build</code></pre></li>
  </ol>
  <li>Check the status of the new MIH server using Portainer. <code>https://localhost:9443/</code> (Change Local Host to IP if necessary).</li>
  <ol>
    <li>If all containers are running without errors, proceed to step 5 (<b>NOTE:</b> certbot container will stop after running successfully).</li>
    <li>If MIH-Minio did not start correctly, run <code>sudo chown 1001 File_Storage/</code> in the project directory, stop MIH Server (see details below), then start from step 3 again. <pre><code>sudo chown 1001 File_Storage</code></pre></li>
  </ol>
  <li>Set Up MIH-Minio config</li>
  <ol>
    <li>Access MIH-Minio using <code>https://localhost:9001/login</code> (Change Localhost to IP if necessary).</li>
    <li>Add/ Generate access key to MIH-Minio.</li>
    <li>Create a bucket called mih.</li>
    <li>Non-Prod: make the mih bucket public.</li>
    <li>Prod: keep the mih bucket private.</li>
  </ol>
  <li>CONTINUE HERE</li>
</ol>

<h2>How to Stop MIH Server:-</h2>
<ol>
   <li>Non-Prod: <pre><code>sudo docker compose down</code></pre></li>
    <li>Prod: <pre><code>sudo docker compose --profile prod down</code></pre></li>
    <li>Prod with Letsincrypt certificate Generation: <pre><code>sudo docker compose --profile prod --profile withCert down</code></pre></li>
</ol>
