window.addEventListener('message', (e) => {
let data = e.data;

function formatNumber(num) {
    return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1.');
}

switch (data.action) {
case 'load':
    for (let i = 0; i < data.jobs.length; i++) {
        let job = data.jobs[i];

        $('.container').append(`
            <div class="trabajos ${job.name}">
                ${job.icon} <span>${job.count}</span>
            </div>
        `);
        
    }
    break;

case 'update':
    for (let i = 1; i < data.jobs.length; i++) {
        let job = data.jobs[i];

        $(`.${job.name} span`).html(`${job.count}`);
    }
    
    break;

case 'mapasi':
    anime({
        targets: '.vidas',
        translateX: data.anchor.x + data.anchor.width * screen.width + 20,
        translateY: 0,
        rotate: 360,
        delay: 300,
        duration: 500,
        easing: 'easeOutElastic(.6, 1)',
    });
    break;

case 'mapafuera':
    anime({
        targets: '.vidas',
        translateX: 0,
        translateY: 0,
        rotate: 0,
        delay: 0,
        duration: 500,
        easing: 'easeOutElastic(.6, 1)',
    });
    break;

case 'toggle':
    if (data.toggle) {
        $('body').fadeOut(250);
    } else {
        $('body').fadeIn(250);
    }
    break;

case 'show':
    $('.todo').show(250);
    break;

case 'act':
    $('.trabajoda').text(`${data.job_label.toUpperCase()} - ${data.job_grade_label.toUpperCase()}`);

    $('#id').html('ID : ' + data.id);

    $('#blackmoney').html(formatNumber(data.accounts['black_money'].money));
    $('#dinero').html(formatNumber(data.accounts['money'].money));
    $('#bank').html(formatNumber(data.accounts['bank'].money));
    
    $("#vidaBar").css({
        height: Math.round(data.health) + '%',
        background: `${data.colorvida}`,
        top: 100 - Math.round(data.health) + '%',
    });
    $("#comida").css({
        height: Math.round(data.hunger) + '%',
        background: `${data.colorcomida}`,
        top: 100 - Math.round(data.hunger) + '%',
    });
    $("#bebida").css({
        height: Math.round(data.thirst) + '%',
        background: `${data.colorbebida}`,
        top: 100 - Math.round(data.thirst) + '%',
    });
    $("#armadura").css({
        height: Math.round(data.armour) + '%',
        background: `${data.colorarmadura}`,
        top: 100 - Math.round(data.armour) + '%',
    });
    $("#estamina").css({
        background: `${data.colorestamina}`,
        height: Math.round(data.stamina) + '%',
        top: 100 - Math.round(data.stamina) + '%',
    });

    if (data.stamina > -1 && data.stamina < 95) {
        $('.sta').show(250);
    } else {
        $("#estamina").css({ height: '0%', top: '100%' });
        $('.sta').hide(250);
    }                

    if (data.armour > 1 && data.armour < 150) {
        $('.armor').show(250);
    } else {
        $("#armadura").css({ height: '0%', top: '100%' });
        $('.armor').hide(250);
    }
    break;
}
});
