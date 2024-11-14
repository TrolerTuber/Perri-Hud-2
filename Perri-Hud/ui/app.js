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

    case 'updatecolors': 
        $("#vidaBar").css({ background: `${data.colorvida}` });
        $("#comida").css({ background: `${data.colorcomida}` });
        $("#bebida").css({ background: `${data.colorbebida}` });
        $("#armadura").css({ background: `${data.colorarmadura}` });
        $("#estamina").css({ background: `${data.colorestamina}` });    
    break;
    
    case 'mapasi':
        anime({
            targets: '.container-status',
            translateX: data.mapa ? (data.anchor.x + data.anchor.width * screen.width + 20) : 0,
            translateY: 0,
            rotate: data.mapa ? 360 : 0,
            delay: 300,
            duration: 500,
            easing: 'easeOutElastic(.6, 1)',
        });
    break;

    case 'toggle':
        let toggle = (data.toggle) ? $('body').fadeOut(250) : $('body').fadeIn(250);
    break;

    case 'show':
        $('.todo').show(250);
    break;

    case 'job': 
        $('.trabajoda').text(`${data.job_label.toUpperCase()} - ${data.job_grade_label.toUpperCase()}`);
    break;

    case 'act':
        $('#id').html(`ID: ${data.id}`);

        $('#blackmoney').html(formatNumber(data.accounts['black_money'].money));
        $('#dinero').html(formatNumber(data.accounts['money'].money));
        $('#bank').html(formatNumber(data.accounts['bank'].money));
        (data.hablando) ? $('#hablando').html('<i class="fa-solid fa-microphone"></i>') : $('#hablando').html('<i class="fa-solid fa-microphone-slash"></i>');    

        $("#vidaBar").css({
            height: Math.round(data.health) + '%',
            top: 100 - Math.round(data.health) + '%',
        });
        $("#comida").css({
            height: Math.round(data.hunger) + '%',
            top: 100 - Math.round(data.hunger) + '%',
        });
        $("#bebida").css({
            height: Math.round(data.thirst) + '%',
            top: 100 - Math.round(data.thirst) + '%',
        });
        $("#armadura").css({
            height: Math.round(data.armour) + '%',
            top: 100 - Math.round(data.armour) + '%',
        });
        $("#estamina").css({
            height: Math.round(data.stamina) + '%',
            top: 100 - Math.round(data.stamina) + '%',
        });

        if (data.stamina >= 0 && data.stamina < 95) {
            $('.sta').show(250);
        } else {
            $("#estamina").css({ height: '0%', top: '100%' });
            $('.sta').hide(250);
        }                

        if (data.armour > 0 && data.armour <= 100) {
            $('.armor').show(250);
        } else {
            $("#armadura").css({ height: '0%', top: '100%' });
            $('.armor').hide(250);
        }
    break;
    }
});



