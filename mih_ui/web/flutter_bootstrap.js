{{flutter_js}}
{{flutter_build_config}}

const serviceWorkerVersion = '{{flutter_service_worker_version}}';

if ('serviceWorker' in navigator) {
  window.addEventListener('load', function () {
    const serviceWorkerUrl = 'flutter_service_worker.js?v=' + serviceWorkerVersion;
    
    // Manually register here so we can attach custom update listeners
    navigator.serviceWorker.register(serviceWorkerUrl).then((reg) => {
      if (reg.waiting) {
        showUpdatePrompt(reg);
      }

      reg.addEventListener('updatefound', () => {
        const newWorker = reg.installing;
        newWorker.addEventListener('statechange', () => {
          if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
            showUpdatePrompt(reg);
          }
        });
      });
    });

    let refreshing = false;
    navigator.serviceWorker.addEventListener('controllerchange', () => {
      if (!refreshing) {
        refreshing = true;
        window.location.reload();
      }
    });
  });
}

function showUpdatePrompt(reg) {
  if (confirm('A new version of MIH is available. Refresh now to update?')) {
    reg.unregister().then(function () {
      window.location.reload(); // Bypass cache and reload
    });
  }
}

// Initialize Flutter and pass the service worker version
_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: serviceWorkerVersion
  }
});
