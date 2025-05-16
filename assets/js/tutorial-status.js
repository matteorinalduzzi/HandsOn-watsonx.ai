document.addEventListener('DOMContentLoaded', () => {
    const table = document.querySelector('table');
    const headerRow = table.querySelector('thead tr');
    const tableRows = table.querySelectorAll('tbody tr');

    // Add a new header for the checkmarks
    const checkHeader = document.createElement('th');
    checkHeader.textContent = 'Done';
    checkHeader.style.textAlign = 'center';
    headerRow.appendChild(checkHeader);

    tableRows.forEach(row => {
        const link = row.querySelector('a');
        if (!link) return;

        const href = link.getAttribute('href');
        const stepId = `completed-${href}`;

        // Create a new cell for the checkmark
        const checkmarkCell = document.createElement('td');
        checkmarkCell.style.textAlign = 'center';
        row.appendChild(checkmarkCell);

        // If completed, show checkmark
        const isCompleted = localStorage.getItem(stepId) === 'true';
        checkmarkCell.textContent = isCompleted ? '☑' : '☐';

        // Mark as completed on click
        link.addEventListener('click', () => {
            localStorage.setItem(stepId, 'true');
        });
    });

    const resetButton = document.getElementById('reset-progress');
    if (resetButton) {
        resetButton.addEventListener('click', (e) => {
            e.preventDefault();

            // Remove only the keys related to step completion
            Object.keys(localStorage).forEach(key => {
                if (key.startsWith('completed-')) {
                    localStorage.removeItem(key);
                }
            });

            // Refresh to reflect the cleared state
            window.location.reload();
        });
    }
});
