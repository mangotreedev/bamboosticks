const initAlerts = () => {
  const alerts = document.querySelectorAll('[role="alert"]');

  const hideAlert = (event) => { event.currentTarget.closest('[role="alert"]').classList.add('hidden')};

  alerts.forEach(alert => alert.querySelector('[role="button"]').addEventListener('click', hideAlert));
};

export default initAlerts;