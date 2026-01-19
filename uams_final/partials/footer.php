    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<script>
(function(){
  try {
    const triggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    triggerList.forEach(function (el) { new bootstrap.Tooltip(el); });
  } catch (e) {}
})();
</script>
<?php if (!empty($page_scripts)) echo $page_scripts; ?>
</body>
</html>
