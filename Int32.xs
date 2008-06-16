/* -*- Mode: C -*- */

#define PERL_NO_GET_CONTEXT 1

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

static HV *package_int32_stash;
static HV *package_uint32_stash;

#if !defined(INT32_HAS_ATOLL)
#  if defined(INT32_HAS_STRTOLL)
#    define atoll(x) strtoll((x), NULL, 10)
#  else
#    error "no int32 parsing function available from C library"
#  endif
#endif

#if !defined(INT32_HAS_ATOULL)
#  if defined(INT32_HAS_STRTOULL)
#    define atoull(x) strtoull((x), NULL, 10)
#  else
#    define atoull(x) atoll(x)
#  endif
#endif

#if defined(INT32_BACKEND_DOUBLE)

int
SvI32OK(pTHX_ SV *sv) {
    if (SvROK(sv)) {
        SV *si32 = SvRV(sv);
        return (si32 && (SvTYPE(si32) == SVt_PVMG) && sv_isa(sv, "Math::Int32"));
    }
    return 0;
}

int
SvU32OK(pTHX_ SV *sv) {
    if (SvROK(sv)) {
        SV *su32 = SvRV(sv);
        return (su32 && (SvTYPE(su32) == SVt_PVMG) && sv_isa(sv, "Math::UInt32"));
    }
    return 0;
}

SV *
newSVi32(pTHX_ int32_t i32) {
    SV *sv;
    SV *si32 = newSV(0);
    SvUPGRADE(si32, SVt_PVMG);
    *(int32_t*)(&(SvNVX(si32))) = i32;
    sv = newRV_noinc(si32);
    sv_bless(sv, package_int32_stash);
    return sv;
}

SV *
newSVu32(pTHX_ uint32_t u32) {
    SV *sv;
    SV *su32 = newSV(0);
    SvUPGRADE(su32, SVt_PVMG);
    *(int32_t*)(&(SvNVX(su32))) = u32;
    sv = newRV_noinc(su32);
    sv_bless(sv, package_uint32_stash);
    return sv;
}

#define SvI32X(sv) (*(int32_t*)(&(SvNVX(SvRV(sv)))))

#define SvU32X(sv) (*(uint32_t*)(&(SvNVX(SvRV(sv)))))

SV *
SvSI32(pTHX_ SV *sv) {
    if (SvRV(sv)) {
        SV *si32 = SvRV(sv);
        if (si32 && (SvTYPE(si32) == SVt_PVMG))
            return si32;
    }
    Perl_croak(aTHX_ "internal error: reference to NV expected");
}

SV *
SvSU32(pTHX_ SV *sv) {
    if (SvRV(sv)) {
        SV *su32 = SvRV(sv);
        if (su32 && (SvTYPE(su32) == SVt_PVMG))
            return su32;
    }
    Perl_croak(aTHX_ "internal error: reference to NV expected");
}

#define SvI32x(sv) (*(int32_t*)(&(SvNVX(SvSI32(aTHX_ sv)))))

#define SvU32x(sv) (*(uint32_t*)(&(SvNVX(SvSU32(aTHX_ sv)))))

int32_t
SvI32(pTHX_ SV *sv) {
    if (!SvOK(sv)) {
        return 0;
    }
    if (SvIOK_UV(sv)) {
        return SvUV(sv);
    }
    if (SvIOK(sv)) {
        return SvIV(sv);
    }
    if (SvNOK(sv)) {
        return SvNV(sv);
    }
    if (SvROK(sv)) {
        SV *si32 = SvRV(sv);
        if (si32 && (SvTYPE(si32) == SVt_PVMG) && (sv_isa(sv, "Math::Int32") || sv_isa(sv, "Math::UInt32"))) {
            return *(int32_t*)(&(SvNVX(si32)));
        }
    }
    return atoll(SvPV_nolen(sv));
}

uint32_t
SvU32(pTHX_ SV *sv) {
    if (!SvOK(sv)) {
        return 0;
    }
    if (SvIOK_UV(sv)) {
        return SvUV(sv);
    }
    if (SvIOK(sv)) {
        return SvIV(sv);
    }
    if (SvNOK(sv)) {
        return SvNV(sv);
    }
    if (SvROK(sv)) {
        SV *su32 = SvRV(sv);
        if (su32 && (SvTYPE(su32) == SVt_PVMG) && (sv_isa(sv, "Math::UInt32")) || sv_isa(sv, "Math::Int32"))
            return *(uint32_t*)(&(SvNVX(su32)));
    }
    return atoull(SvPV_nolen(sv));
}

SV *
si32_to_number(pTHX_ SV *sv) {
    int32_t i32 = SvI32x(sv);
    IV iv;
    UV uv;
    uv = i32;
    if (uv == i32)
        return newSVuv(uv);
    iv = i32;
    if (iv == i32)
        return newSViv(iv);
    return newSVnv(i32);
}

SV *
su32_to_number(pTHX_ SV *sv) {
    uint32_t u32 = SvU32x(sv);
    IV iv;
    UV uv;
    uv = u32;
    if (uv == u32)
        return newSVuv(uv);
    iv = u32;
    if (iv == u32)
        return newSViv(iv);
    return newSVnv(u32);
}

#elif defined(INT32_BACKEND_STRING)

#elif defined(INT32_BACKEND_NATIVE)

#endif


MODULE = Math::Int32		PACKAGE = Math::Int32		PREFIX=miu32_
PROTOTYPES: DISABLE

BOOT:
package_int32_stash = gv_stashsv(newSVpv("Math::Int32", 0), 1);
package_uint32_stash = gv_stashsv(newSVpv("Math::UInt32", 0), 1);

SV *
miu32_int32(value=&PL_sv_undef)
    SV *value;
CODE:
    RETVAL = newSVi32(aTHX_ SvI32(aTHX_ value));
OUTPUT:
    RETVAL

SV *
miu32_uint32(value=&PL_sv_undef)
    SV *value;
CODE:
    RETVAL = newSVu32(aTHX_ SvU32(aTHX_ value));
OUTPUT:
    RETVAL

SV *
miu32_int32_to_number(self)
    SV *self
CODE:
    RETVAL = si32_to_number(aTHX_ self);
OUTPUT:
    RETVAL

SV *
miu32_uint32_to_number(self)
    SV *self
CODE:
    RETVAL = su32_to_number(aTHX_ self);
OUTPUT:
    RETVAL

SV *
miu32_net_to_int32(net)
    SV *net;
PREINIT:
    STRLEN len;
    unsigned char *pv = (unsigned char *)SvPV(net, len);
CODE:
    if (len != 4)
        Perl_croak(aTHX_ "Invalid length for int32");
    RETVAL = newSVi32(aTHX_
                     (((((((int32_t)pv[0]) << 8)
                         + (int32_t)pv[1]) << 8)
                         + (int32_t)pv[2]) << 8)
                         + (int32_t)pv[3]);
OUTPUT:
    RETVAL

SV *
miu32_net_to_uint32(net)
    SV *net;
PREINIT:
    STRLEN len;
    unsigned char *pv = (unsigned char *)SvPV(net, len);
CODE:
    if (len != 4)
        Perl_croak(aTHX_ "Invalid length for uint32");
    RETVAL = newSVu32(aTHX_
                     (((((((uint32_t)pv[0]) << 8)
                         + (uint32_t)pv[1]) << 8)
                         + (uint32_t)pv[2]) << 8)
                         + (uint32_t)pv[4]);
OUTPUT:
    RETVAL

SV *
miu32_int32_to_net(self)
    SV *self
PREINIT:
    char *pv;
    int32_t i32 = SvI32(aTHX_ self);
    int i;
CODE:
    RETVAL = newSV(4);
    SvPOK_on(RETVAL);
    SvCUR_set(RETVAL, 4);
    pv = SvPVX(RETVAL);
    pv[4] = '\0';
    for (i = 3; i >= 0; i--, i32 >>= 8)
        pv[i] = i32;
OUTPUT:
    RETVAL

SV *
miu32_uint32_to_net(self)
    SV *self
PREINIT:
    char *pv;
    uint32_t u32 = SvU32(aTHX_ self);
    int i;
CODE:
    RETVAL = newSV(4);
    SvPOK_on(RETVAL);
    SvCUR_set(RETVAL, 4);
    pv = SvPVX(RETVAL);
    pv[4] = '\0';
    for (i = 3; i >= 0; i--, u32 >>= 8)
        pv[i] = u32;
OUTPUT:
    RETVAL

SV *
miu32_native_to_int32(native)
    SV *native
PREINIT:
    STRLEN len;
    char *pv = SvPV(native, len);
CODE:
    if (len != 4)
        Perl_croak(aTHX_ "Invalid length for int32");
    RETVAL = newSVi32(aTHX_ 0);
    Copy(pv, &(SvI32X(RETVAL)), 4, char);
OUTPUT:
    RETVAL

SV *
miu32_native_to_uint32(native)
    SV *native
PREINIT:
    STRLEN len;
    char *pv = SvPV(native, len);
CODE:
    if (len != 4)
        Perl_croak(aTHX_ "Invalid length for uint32");
    RETVAL = newSVu32(aTHX_ 0);
    Copy(pv, &(SvU32X(RETVAL)), 4, char);
OUTPUT:
    RETVAL

SV *
miu32_int32_to_native(self)
    SV *self
PREINIT:
    char *pv;
    int32_t i32 = SvI32(aTHX_ self);
CODE:
    RETVAL = newSV(4);
    SvPOK_on(RETVAL);
    SvCUR_set(RETVAL, 4);
    pv = SvPVX(RETVAL);
    Copy(&i32, pv, 4, char);
OUTPUT:
    RETVAL

SV *
miu32_uint32_to_native(self)
    SV *self
PREINIT:
    char *pv;
    uint32_t u32 = SvU32(aTHX_ self);
CODE:
    RETVAL = newSV(4);
    SvPOK_on(RETVAL);
    SvCUR_set(RETVAL, 4);
    pv = SvPVX(RETVAL);
    Copy(&u32, pv, 4, char);
OUTPUT:
    RETVAL


MODULE = Math::Int32		PACKAGE = Math::Int32		PREFIX=mi32
PROTOTYPES: DISABLE

SV *
mi32_inc(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    SvI32x(self)++;
    RETVAL = self;
    SvREFCNT_inc(RETVAL);
OUTPUT:
    RETVAL

SV *
mi32_dec(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    SvI32x(self)--;
    RETVAL = self;
    SvREFCNT_inc(RETVAL);
OUTPUT:
    RETVAL

SV *
mi32_add(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    /*
    fprintf(stderr, "self: ");
    sv_dump(self);
    fprintf(stderr, "other: ");
    sv_dump(other);
    fprintf(stderr, "rev: ");
    sv_dump(rev);
    fprintf(stderr, "\n");
    */
    if (SvOK(rev)) 
        RETVAL = newSVi32(aTHX_ SvI32x(self) + SvI32(aTHX_ other));
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvI32x(self) += SvI32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *
mi32_sub(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvOK(rev))
        RETVAL = newSVi32(aTHX_
                          SvTRUE(rev)
                          ? SvI32(aTHX_ other) - SvI32x(self)
                          : SvI32x(self) - SvI32(aTHX_ other));
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvI32x(self) -= SvI32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *
mi32_mul(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvOK(rev))
        RETVAL = newSVi32(aTHX_ SvI32x(self) * SvI32(aTHX_ other));
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvI32x(self) *= SvI32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *
mi32_div(self, other, rev)
    SV *self
    SV *other
    SV *rev
PREINIT:
    int32_t up;
    int32_t down;
CODE:
    if (SvOK(rev)) {
        if (SvTRUE(rev)) {
            up = SvI32(aTHX_ other);
            down = SvI32x(self);
        }
        else {
            up = SvI32x(self);
            down = SvI32(aTHX_ other);
        }
        if (!down)
            Perl_croak(aTHX_ "Illegal division by zero");
        RETVAL = newSVi32(aTHX_ up/down);
    }
    else {
        down = SvI32(aTHX_ other);
        if (!down)
            Perl_croak(aTHX_ "Illegal division by zero");
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvI32x(self) /= down;
    }
OUTPUT:
    RETVAL

SV *
mi32_rest(self, other, rev)
    SV *self
    SV *other
    SV *rev
PREINIT:
    int32_t up;
    int32_t down;
CODE:
    if (SvOK(rev)) {
        if (SvTRUE(rev)) {
            up = SvI32(aTHX_ other);
            down = SvI32x(self);
        }
        else {
            up = SvI32x(self);
            down = SvI32(aTHX_ other);
        }
        if (!down)
            Perl_croak(aTHX_ "Illegal division by zero");
        RETVAL = newSVi32(aTHX_ up % down);
    }
    else {
        down = SvI32(aTHX_ other);
        if (!down)
            Perl_croak(aTHX_ "Illegal division by zero");
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvI32x(self) %= down;
    }
OUTPUT:
    RETVAL

SV *mi32_left(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvOK(rev))
        RETVAL = newSVi32(aTHX_
                          SvTRUE(rev)
                          ? SvI32(aTHX_ other) << SvI32x(self)
                          : SvI32x(self) << SvI32(aTHX_ other) );
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvI32x(self) <<= SvI32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *mi32_right(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvOK(rev))
        RETVAL = newSVi32(aTHX_
                          SvTRUE(rev)
                          ? SvI32(aTHX_ other) >> SvI32x(self)
                          : SvI32x(self) >> SvI32(aTHX_ other) );
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvI32x(self) >>= SvI32(aTHX_ other);
    }
OUTPUT:
    RETVAL

int
mi32_spaceship(self, other, rev)
    SV *self
    SV *other
    SV *rev
PREINIT:
    int32_t left;
    int32_t right;
CODE:
    if (SvTRUE(rev)) {
        left = SvI32(aTHX_ other);
        right = SvI32x(self);
    }
    else {
        left = SvI32x(self);
        right = SvI32(aTHX_ other);
    }
    RETVAL = (left < right ? -1 : left > right ? 1 : 0);
OUTPUT:
    RETVAL

SV *
mi32_eqn(self, other, rev)
    SV *self
    SV *other
    SV *rev = NO_INIT
CODE:
    RETVAL = ( SvI32x(self) == SvI32(aTHX_ other)
               ? &PL_sv_yes
               : &PL_sv_no );
OUTPUT:
    RETVAL

SV *
mi32_nen(self, other, rev)
    SV *self
    SV *other
    SV *rev = NO_INIT
CODE:
    RETVAL = ( SvI32x(self) != SvI32(aTHX_ other)
               ? &PL_sv_yes
               : &PL_sv_no );
OUTPUT:
    RETVAL

SV *
mi32_gtn(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvTRUE(rev))
        RETVAL = SvI32x(self) < SvI32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
    else
        RETVAL = SvI32x(self) > SvI32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
OUTPUT:
    RETVAL

SV *
mi32_ltn(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvTRUE(rev))
        RETVAL = SvI32x(self) > SvI32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
    else
        RETVAL = SvI32x(self) < SvI32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
OUTPUT:
    RETVAL

SV *
mi32_gen(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvTRUE(rev))
        RETVAL = SvI32x(self) <= SvI32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
    else
        RETVAL = SvI32x(self) >= SvI32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
OUTPUT:
    RETVAL

SV *
mi32_len(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvTRUE(rev))
        RETVAL = SvI32x(self) >= SvI32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
    else
        RETVAL = SvI32x(self) <= SvI32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
OUTPUT:
    RETVAL

SV *
mi32_and(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvOK(rev))
        RETVAL = newSVi32(aTHX_ SvI32x(self) & SvI32(aTHX_ other));
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvI32x(self) &= SvI32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *
mi32_or(self, other, rev)
    SV *self
    SV *other
    SV *rev = NO_INIT
CODE:
    if (SvOK(rev))
        RETVAL = newSVi32(aTHX_ SvI32x(self) | SvI32(aTHX_ other));
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvI32x(self) |= SvI32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *
mi32_xor(self, other, rev)
    SV *self
    SV *other
    SV *rev = NO_INIT
CODE:
    if (SvOK(rev))
        RETVAL = newSVi32(aTHX_ SvI32x(self) ^ SvI32(aTHX_ other));
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvI32x(self) ^= SvI32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *
mi32_not(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    RETVAL = SvI32x(self) ? &PL_sv_no : &PL_sv_yes;
OUTPUT:
    RETVAL

SV *
mi32_bnot(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    RETVAL = newSVi32(aTHX_ ~SvI32x(self));
OUTPUT:
    RETVAL    

SV *
mi32_neg(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    RETVAL = newSVi32(aTHX_ -SvI32x(self));
OUTPUT:
    RETVAL

SV *
mi32_bool(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    RETVAL = SvI32x(self) ? &PL_sv_yes : &PL_sv_no;
OUTPUT:
    RETVAL

SV *
mi32_number(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    RETVAL = si32_to_number(aTHX_ self);
OUTPUT:
    RETVAL

SV *
mi32_clone(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    RETVAL = newSVi32(aTHX_ SvI32x(self));
OUTPUT:
    RETVAL

SV *
mi32_string(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
PREINIT:
    STRLEN len;
CODE:
    RETVAL = newSV(22);
    SvPOK_on(RETVAL);
    SvCUR_set(RETVAL, sprintf(SvPVX(RETVAL), "%d", SvI32x(self)));
OUTPUT:
    RETVAL


MODULE = Math::Int32		PACKAGE = Math::UInt32		PREFIX=mu32
PROTOTYPES: DISABLE

SV *
mu32_inc(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    SvU32x(self)++;
    RETVAL = self;
    SvREFCNT_inc(RETVAL);
OUTPUT:
    RETVAL

SV *
mu32_dec(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    SvU32x(self)--;
    RETVAL = self;
    SvREFCNT_inc(RETVAL);
OUTPUT:
    RETVAL

SV *
mu32_add(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    /*
    fprintf(stderr, "self: ");
    sv_dump(self);
    fprintf(stderr, "other: ");
    sv_dump(other);
    fprintf(stderr, "rev: ");
    sv_dump(rev);
    fprintf(stderr, "\n");
    */
    if (SvOK(rev)) 
        RETVAL = newSVu32(aTHX_ SvU32x(self) + SvU32(aTHX_ other));
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvU32x(self) += SvU32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *
mu32_sub(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvOK(rev))
        RETVAL = newSVu32(aTHX_
                          SvTRUE(rev)
                          ? SvU32(aTHX_ other) - SvU32x(self)
                          : SvU32x(self) - SvU32(aTHX_ other));
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvU32x(self) -= SvU32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *
mu32_mul(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvOK(rev))
        RETVAL = newSVu32(aTHX_ SvU32x(self) * SvU32(aTHX_ other));
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvU32x(self) *= SvU32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *
mu32_div(self, other, rev)
    SV *self
    SV *other
    SV *rev
PREINIT:
    uint32_t up;
    uint32_t down;
CODE:
    if (SvOK(rev)) {
        if (SvTRUE(rev)) {
            up = SvU32(aTHX_ other);
            down = SvU32x(self);
        }
        else {
            up = SvU32x(self);
            down = SvU32(aTHX_ other);
        }
        if (!down)
            Perl_croak(aTHX_ "Illegal division by zero");
        RETVAL = newSVu32(aTHX_ up/down);
    }
    else {
        down = SvU32(aTHX_ other);
        if (!down)
            Perl_croak(aTHX_ "Illegal division by zero");
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvU32x(self) /= down;
    }
OUTPUT:
    RETVAL

SV *
mu32_rest(self, other, rev)
    SV *self
    SV *other
    SV *rev
PREINIT:
    uint32_t up;
    uint32_t down;
CODE:
    if (SvOK(rev)) {
        if (SvTRUE(rev)) {
            up = SvU32(aTHX_ other);
            down = SvU32x(self);
        }
        else {
            up = SvU32x(self);
            down = SvU32(aTHX_ other);
        }
        if (!down)
            Perl_croak(aTHX_ "Illegal division by zero");
        RETVAL = newSVu32(aTHX_ up % down);
    }
    else {
        down = SvU32(aTHX_ other);
        if (!down)
            Perl_croak(aTHX_ "Illegal division by zero");
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvU32x(self) %= down;
    }
OUTPUT:
    RETVAL

SV *mu32_left(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvOK(rev))
        RETVAL = newSVu32(aTHX_
                          SvTRUE(rev)
                          ? SvU32(aTHX_ other) << SvU32x(self)
                          : SvU32x(self) << SvU32(aTHX_ other) );
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvU32x(self) <<= SvU32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *mu32_right(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvOK(rev))
        RETVAL = newSVu32(aTHX_
                          SvTRUE(rev)
                          ? SvU32(aTHX_ other) >> SvU32x(self)
                          : SvU32x(self) >> SvU32(aTHX_ other) );
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvU32x(self) >>= SvU32(aTHX_ other);
    }
OUTPUT:
    RETVAL

int
mu32_spaceship(self, other, rev)
    SV *self
    SV *other
    SV *rev
PREINIT:
    uint32_t left;
    uint32_t right;
CODE:
    if (SvTRUE(rev)) {
        left = SvU32(aTHX_ other);
        right = SvU32x(self);
    }
    else {
        left = SvU32x(self);
        right = SvU32(aTHX_ other);
    }
    RETVAL = (left < right ? -1 : left > right ? 1 : 0);
OUTPUT:
    RETVAL

SV *
mu32_eqn(self, other, rev)
    SV *self
    SV *other
    SV *rev = NO_INIT
CODE:
    RETVAL = ( SvU32x(self) == SvU32(aTHX_ other)
               ? &PL_sv_yes
               : &PL_sv_no );
OUTPUT:
    RETVAL

SV *
mu32_nen(self, other, rev)
    SV *self
    SV *other
    SV *rev = NO_INIT
CODE:
    RETVAL = ( SvU32x(self) != SvU32(aTHX_ other)
               ? &PL_sv_yes
               : &PL_sv_no );
OUTPUT:
    RETVAL

SV *
mu32_gtn(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvTRUE(rev))
        RETVAL = SvU32x(self) < SvU32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
    else
        RETVAL = SvU32x(self) > SvU32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
OUTPUT:
    RETVAL

SV *
mu32_ltn(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvTRUE(rev))
        RETVAL = SvU32x(self) > SvU32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
    else
        RETVAL = SvU32x(self) < SvU32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
OUTPUT:
    RETVAL

SV *
mu32_gen(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvTRUE(rev))
        RETVAL = SvU32x(self) <= SvU32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
    else
        RETVAL = SvU32x(self) >= SvU32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
OUTPUT:
    RETVAL

SV *
mu32_len(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvTRUE(rev))
        RETVAL = SvU32x(self) >= SvU32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
    else
        RETVAL = SvU32x(self) <= SvU32(aTHX_ other) ? &PL_sv_yes : &PL_sv_no;
OUTPUT:
    RETVAL

SV *
mu32_and(self, other, rev)
    SV *self
    SV *other
    SV *rev
CODE:
    if (SvOK(rev))
        RETVAL = newSVu32(aTHX_ SvU32x(self) & SvU32(aTHX_ other));
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvU32x(self) &= SvU32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *
mu32_or(self, other, rev)
    SV *self
    SV *other
    SV *rev = NO_INIT
CODE:
    if (SvOK(rev))
        RETVAL = newSVu32(aTHX_ SvU32x(self) | SvU32(aTHX_ other));
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvU32x(self) |= SvU32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *
mu32_xor(self, other, rev)
    SV *self
    SV *other
    SV *rev = NO_INIT
CODE:
    if (SvOK(rev))
        RETVAL = newSVu32(aTHX_ SvU32x(self) ^ SvU32(aTHX_ other));
    else {
        RETVAL = self;
        SvREFCNT_inc(RETVAL);
        SvU32x(self) ^= SvU32(aTHX_ other);
    }
OUTPUT:
    RETVAL

SV *
mu32_not(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    RETVAL = SvU32x(self) ? &PL_sv_no : &PL_sv_yes;
OUTPUT:
    RETVAL

SV *
mu32_bnot(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    RETVAL = newSVu32(aTHX_ ~SvU32x(self));
OUTPUT:
    RETVAL    

SV *
mu32_neg(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    RETVAL = newSVu32(aTHX_ -SvU32x(self));
OUTPUT:
    RETVAL

SV *
mu32_bool(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    RETVAL = SvU32x(self) ? &PL_sv_yes : &PL_sv_no;
OUTPUT:
    RETVAL

SV *
mu32_number(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    RETVAL = su32_to_number(aTHX_ self);
OUTPUT:
    RETVAL

SV *
mu32_clone(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
CODE:
    RETVAL = newSVu32(aTHX_ SvU32x(self));
OUTPUT:
    RETVAL

SV *
mu32_string(self, other, rev)
    SV *self
    SV *other = NO_INIT
    SV *rev = NO_INIT
PREINIT:
    STRLEN len;
CODE:
    RETVAL = newSV(22);
    SvPOK_on(RETVAL);
    SvCUR_set(RETVAL, sprintf(SvPVX(RETVAL), "%u", SvU32x(self)));
OUTPUT:
    RETVAL








    
