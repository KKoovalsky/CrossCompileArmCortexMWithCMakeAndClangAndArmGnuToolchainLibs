#include <exception>
#include <stdexcept>
#include <string>

int main(void)
{
    try
    {
        throw std::runtime_error{"Error!"};
    }
    catch (const std::exception&)
    {
    }   

    return 0;
}
