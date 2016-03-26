//= require jquery
//= require js.cookie

$(document).ready(function () {
    $(".auth__button").click(function () {
        $('.auth').removeClass('auth__hidden');
    });
    $(".form__label").click(function () {
        if ($(this).hasClass('is-closed')) {
            $("input[id='" + $(this).attr('for') + "']").removeClass("is-closed");
            $(this).removeClass('is-closed');
        }
    });


    $(".form__input").focus(function () {
        if ($(this).hasClass('is-closed')) {
            $("label[for='" + $(this).attr('id') + "']").removeClass("is-closed");
            $(this).removeClass('is-closed');
        }
    });


    $(".form__submit").click(function (e) {
            if (!$(this).hasClass('form__submit--animated--ok')) {
                e.preventDefault();
                var cath = 'Заполните необходимые поля!';
                var login = $('#login-id').val();
                var pswd = $('#password').val();
                if ('Login' == $('.form__submit').text()) {
                    $.get('/api/login?login=' + login + '&pswd=' + pswd, function (data) {
                        if (data.err_code === undefined) {
                            finish(true, null, data.token);
                        } else {
                            finish(false, data.text, null);
                        }
                        //console.log(json.err_code);
                    });
                } else {
                    var name = $('#name-id').val();
                    try {
                        $.get('/api/register?login=' + login + '&pswd=' + pswd + '&name=' + name, function (data) {
                            if (data.err_code === undefined) {
                                $.get('/api/login?login=' + login + '&pswd=' + pswd, function (data) {
                                    if (data.err_code === undefined) {
                                        finish(true, null, data.token);
                                    } else {
                                        finish(false, data.text, null);
                                    }
                                });
                            } else {
                                finish(false, data.text, null);
                            }
                        });
                    } catch (err) {
                        finish(false, cath, null);
                    }
                }
            }
        }
    );

    function finish(isOk, cath, token) {
        if (isOk) {
            $('.action_button').addClass('action_button--hide');
            $('.form__submit').addClass('form__submit--animated--ok');
            $(".auth").find(".form__label").remove();
            $(".auth").find(".form__input").remove();
            $.get('/api?method=name&token=' + token, function (data) {
                console.log(data)
                if (data.err_code === undefined) {
                    $('.auth__button').text(data.text);
                    Cookies.set('name', data.text);
                } else {
                    alert(data.text);
                }
            });
            setTimeout(function () {
                $('.auth').addClass('auth__hidden');
            }, 2000);
            Cookies.set('token', token);
        } else {
            $('.action_button').addClass('action_button--hide');
            $(".form__submit").addClass('form__submit--animated--false');
            $('.reset').removeClass('reset--hide').text(cath);
        }
    }

    function sleep(ms) {
        ms += new Date().getTime();
        while (new Date() < ms) {
        }
    }

    $(".action_button").click(function (e) {
        e.preventDefault();
        if ('Login' != $('.action_button').text()) {
            $('.form__submit').text('Register');
            $('.action_button').text('Login');
            $('.form').addClass('form--resize');
            $('.form__group').addClass('form__group--move');
            $('.form__group--hide').addClass('form__group--non-hide');
        } else {
            $('.form__submit').text('Login');
            $('.action_button').text('Register');
            $('.form').removeClass('form--resize');
            $('.form__group').removeClass('form__group--move');
            $('.form__group--hide').removeClass('form__group--non-hide');
        }
    });

    $(".reset").click(function () {
        $('.action_button').removeClass('action_button--hide');
        $('.form__label').addClass('is-closed');
        $('.form__input').addClass('is-closed').val('');
        $('.form__submit').removeClass('form__submit--animated--false');
        $('.reset').addClass('reset--hide');
    });
});