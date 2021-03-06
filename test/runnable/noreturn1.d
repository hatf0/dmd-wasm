alias noreturn = typeof(*null);

extern (C) noreturn exit();

/*****************************************/

bool testf(int i)
{
    return i && assert(0);
}

bool testt(int i)
{
    return i || assert(0);
}

int testa(int i)
{
    if (i && exit())
        return i + 1;
    return i - 1;
}

int testb(int i)
{
    if (i || exit())
        return i + 1;
    return i - 1;
}

void test1()
{
    assert(testf(0) == false);
    assert(testt(1) == true);

    assert(testa(0) == -1);
    assert(testb(3) == 4);
}

/*****************************************/

noreturn exit1() { assert(0); }
noreturn exit2() { assert(0); }


int heli1(int i)
{
    return i ? exit1() : i - 1;
}

int heli2(int i)
{
    return i ? i - 1 : exit1();
}

noreturn heli3(int i)
{
    return i ? exit1() : exit2();
}

void test2()
{
    assert(heli1(0) == -1);
    assert(heli2(1) == 0);
}

/*****************************************/

struct BasicStruct
{
	int firstInt;
	noreturn noRet;
	long lastLong;
}

struct AlignedStruct
{
	int firstInt;
	align(16) noreturn noRet;
	long lastLong;
}

void takeBasic(BasicStruct bs)
{
    assert(bs.firstInt == 13);
    assert(bs.lastLong == 42);

    assert(&bs.noRet == (&bs.firstInt + 1));
}

void takeAligned(AlignedStruct as)
{
    assert(as.firstInt == 99);
    assert(as.lastLong == 0xDEADBEEF);

    assert(&as.noRet == &as.lastLong);
}

void test3()
{
    {
        BasicStruct bs;
        bs.firstInt = 13;
        bs.lastLong = 42;
        takeBasic(bs);
    }
    {
        AlignedStruct as;
        as.firstInt = 99;
        as.lastLong = 0xDEADBEEF;
        takeAligned(as);
    }
}

int main()
{
    test1();
    test2();
    test3();
    return 0;
}
