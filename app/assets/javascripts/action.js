//= require jquery
alert('Test!');

$(".form__label").click(function () {
    if ($(this).hasClass('is-closed')) {
        $("input[id='" + $(this).attr('for') + "']").removeClass("is-closed");
        $(this).removeClass('is-closed');
    }
});

// Focus on Inputs
$(".form__input").focus(function () {
    if ($(this).hasClass('is-closed')) {
        $("label[for='" + $(this).attr('id') + "']").removeClass("is-closed");
        $(this).removeClass('is-closed');
    }
});

// Click on Submit
$(".form__submit").click(function (e) {
    e.preventDefault();
    $('.action_button').remove();
    $(this).addClass('form__submit--animated');
    $('.reset').removeClass('reset--hide');
});


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
// Click on reset
$(".reset").click(function () {
    $('.form__label').addClass('is-closed');
    $('.form__input').addClass('is-closed').val('');
    $('.form__submit').removeClass('form__submit--animated');
    $('.reset').addClass('reset--hide');
});